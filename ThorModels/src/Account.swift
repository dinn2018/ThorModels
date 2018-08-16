//
//  Account.swift
//  ThorKit
//
//  Created by 丁磊 on 2018/7/26.
//  Copyright © 2018年 丁磊. All rights reserved.
//

open class Account: NSObject {
    
    open private(set) var privateKey: Data?
    open private(set) var address: Address?
    open private(set) var mnemonicPhrase: String?
    open private(set) var mnemonicData: Data?

    private override init() {
        super.init()
    }
    
    public convenience init?(privateKey: Data) {
        guard privateKey.count == 32 else { return nil }
        self.init()
        self.setPrivateKey(privateKey: privateKey)
    }
    
    public class func randomMnemonicAccount() -> Account?{
        var data = Bytes(repeating:0,count:16)
        let r = SecRandomCopyBytes(kSecRandomDefault, data.count, &data)
        guard r == noErr else { return nil }
        let mnemonicPhrase = String(cString:mnemonic_from_data(data, Int32(data.count)))
        return Account(mnemonicPhrase: mnemonicPhrase)
    }
    
    public convenience init?(mnemonicPhrase: String) {
        self.init()
        guard self.mnemonic_check(mnemonicPhrase: mnemonicPhrase) else { return nil }
        let node = UnsafeMutablePointer<HDNode>.allocate(capacity: 1)
        defer {
            node.deallocate()
        }
        var seed = Bytes(repeating: 0, count: 64)
        mnemonic_to_seed(mnemonicPhrase.cString(using: String.Encoding.utf8), "", &seed, nil)
        hdnode_from_seed(seed, Int32(seed.count), "secp256k1", node)
        hdnode_private_ckd(node, 0x80000000 | (44))
        hdnode_private_ckd(node, 0x80000000 | (818))
        hdnode_private_ckd(node, 0x80000000 | (0))
        hdnode_private_ckd(node, 0)
        let mirror = Mirror(reflecting: node.pointee.private_key)
        let privateKey = mirror.children.map {$0.value as! Byte}
        self.setPrivateKey(privateKey: privateKey.data)
        self.mnemonicPhrase = mnemonicPhrase
        var fullData = Bytes(repeating: 0, count: 1 + (512 / 8))
        let length = data_from_mnemonic(mnemonicPhrase.cString(using: String.Encoding.utf8), &fullData)
        self.mnemonicData = Bytes(fullData[0..<Int(length)]).data
    }
    
    public func encryptSecretStorageJSON(password: String,callback: @escaping (_ json: String?,_ err: Error?)->Void) -> Cancellable {
        
        let send = {(result: String?,err: Error?) -> Void in
            DispatchQueue.main.async {
                callback(result, err)
            }
        }
        
        let gen = { (count: Int,id: String) -> Bytes in
            var data = Bytes(repeating: 0, count: count)
            guard SecRandomCopyBytes(kSecRandomDefault, data.count, &data) == noErr else {
                throw NSError(domain: "generate failed:"+id , code: 0, userInfo: nil)
            }
            return data
        }
        
        var stop: Int8 = 0
        let cancellable = Cancellable(cancelCallback: {()->Void in
            stop = 1
        })
        
        do {
            let uuid = UUID.init()
            let iv = try gen(16,"iv")
            let salt = try gen(32,"salt")
            let (r,p,n) = (8,1,262144)
            var crypto: [String : Any] = [
                "kdfparams": [
                    "p": p,
                    "r": r,
                    "n": n,
                    "dklen": salt.count,
                    "salt": salt.data.hexString().substring(from: 2)
                ],
                "cipherparams": [
                    "iv": iv.data.hexString().substring(from: 2),
                ],
                "kdf": "scrypt",
                "cipher": "aes-128-ctr"
            ]
            
            let passwordData = password.precomposedStringWithCompatibilityMapping.data(using: String.Encoding.utf8)
            let passwordBytes = passwordData?.bytes
            DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
                var derivedKey = Bytes(repeating: 0, count: 64)
                let status = crypto_scrypt(passwordBytes, passwordData!.count, salt, salt.count, UInt64(n), UInt32(r), UInt32(p), &derivedKey, derivedKey.count, &stop)
                guard status == 0 else {
                    send(nil, NSError(domain: "encrypt failed", code: 0, userInfo: nil))
                    return
                }
                var cipherText = Bytes(repeating: 0, count: 32)
                var counter = Bytes(repeating: 0, count: 16)
                memcpy(&counter, iv, min(iv.count, counter.count))
                let encryptionKey = Bytes(derivedKey[0..<16])
                let ctx = UnsafeMutablePointer<aes_encrypt_ctx>.allocate(capacity: 1)
                defer {
                    ctx.deallocate()
                }
                aes_encrypt_key128(encryptionKey, ctx)
                let aesStatus = aes_ctr_crypt(self.privateKey!.bytes, &cipherText, Int32(self.privateKey!.count), &counter, aes_ctr_cbuf_inc, ctx)
                if aesStatus != EXIT_SUCCESS {
                    send(nil, NSError(domain: "encrypt failed", code: 1, userInfo: nil))
                    return
                }
                crypto["ciphertext"] = cipherText.data.hexString().substring(from: 2)
                
                //Compute the MAC
                var macCheck = Data(capacity: 48)
                macCheck.append(Bytes(derivedKey[16..<32]).data)
                macCheck.append(cipherText.data)
                crypto["mac"] = Crypto.KECCAK256(data: macCheck).hexString().substring(from: 2)
                do {
                    let json: [String:Any] = [
                        "address": self.address!.hexString!.substring(from: 2),
                        "id": uuid.uuidString,
                        "version": 3,
                        "crypto": crypto
                    ]
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.init(rawValue: 0))
                    send(String(data: jsonData, encoding: String.Encoding.utf8), nil)
                } catch let e {
                    print("encrypt err",e)
                    send(nil, e)
                }
            }
        } catch let e {
            print("encrypt err",e)
            send(nil, e)
        }
        return cancellable
    }
    
    public static func decryptSecretStorageJSON(json: String,password: String,callback: @escaping (_ account: Account?,_ err:Error?)->Void) -> Cancellable {
        
        let sendError = { (code: Int,msg: String) -> Void in
            DispatchQueue.main.async {
                callback(nil,NSError(domain: "ThorKit.AccountError", code: code, userInfo: ["msg": msg]))
            }
        }
        var stop: Int8 = 0
        let cancellable = Cancellable(cancelCallback: {()->Void in
            stop = 1
        })
        do {
            if let data = try JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? [String:Any] {
                let version = getData(path: "version", data: data) as? Int
                if version == nil {
                    sendError(DecriptError.unsupportedVersion, "invalid version")
                }
                if version != 3 {
                    sendError(DecriptError.invalidJSON, "version\(String(describing: version)) != 3")
                }
                let expectedAddress = Address(hexString: getData(path: "address", data: data) as? String)
                if expectedAddress == nil {
                    sendError(DecriptError.invalidParameter, "invalied address")
                }
                let kdf = getData(path: "crypto/kdf", data: data) as? String
                let salt = (getData(path: "crypto/kdfparams/salt", data: data) as? String)?.hexadecimal()
                let n = getData(path: "crypto/kdfparams/n", data: data) as? UInt64
                let p = getData(path: "crypto/kdfparams/p", data: data) as? UInt32
                let r = getData(path: "crypto/kdfparams/r", data: data) as? UInt32
                let dklen = getData(path: "crypto/kdfparams/dklen", data: data) as? Int
                if kdf == nil || kdf != "scrypt" || salt == nil || n == nil || p == nil || r == nil || dklen != 32 {
                    sendError(DecriptError.unsupportedKeyDerivationFunction,"invalid KDF parameters")
                }
                let cipher = getData(path: "crypto/cipher", data: data) as? String
                let iv = (getData(path: "crypto/cipherparams/iv", data: data) as? String)?.hexadecimal()
                let cipherText = (getData(path: "crypto/ciphertext", data: data) as? String)?.hexadecimal()
                if cipher != "aes-128-ctr" || iv?.count != 16 || cipherText?.count != 32 {
                    sendError(DecriptError.unsupportedCipher, "invalid cipher parameters")
                }
                let mac = (getData(path: "crypto/mac", data: data) as? String)?.hexadecimal()
                if mac == nil {
                    sendError(DecriptError.invalidParameter, "Bad MAC length \(String(describing: mac?.count))")
                }
                let passwordData = password.precomposedStringWithCompatibilityMapping.data(using: String.Encoding.utf8)
                let passwordBytes = passwordData?.bytes
                DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
                    var derivedKey = Bytes(repeating: 0, count: 64)
                    let status = crypto_scrypt(passwordBytes, passwordData!.count, salt!.bytes, salt!.count, n!, r!, p!, &derivedKey, derivedKey.count, &stop)
                    guard status == 0 else {
                        if status == -2 {
                            sendError(DecriptError.cancelled, "cancelled")
                            return
                        }
                        let reason = "Invalid scrypt parameter (salt=\(String(describing: salt?.hexString())), N=\(String(describing: n)), r=\(String(describing: r)), p=\(String(describing: p)), dekLen=\(derivedKey.count)"
                        sendError(DecriptError.invalidParameter, reason)
                        return
                    }
                    var macCheck = Data(capacity: 48)
                    macCheck.append(Bytes(derivedKey[16..<32]).data)
                    macCheck.append(cipherText!)
                    if Crypto.KECCAK256(data: macCheck) != mac {
                        sendError(DecriptError.wrongPassword, "wrong password")
                        return
                    }
                    
                    var privateKey = Bytes(repeating: 0, count: 32)
                    let encryptionKey = derivedKey[0..<16]
                    var counter = Bytes(repeating: 0, count: 16)
                    memcpy(&counter, iv!.bytes, min(iv!.count, counter.count))
                    let ctx = UnsafeMutablePointer<aes_encrypt_ctx>.allocate(capacity: 1)
                    defer {
                        ctx.deallocate()
                    }
                    aes_encrypt_key128(Bytes(encryptionKey), ctx)
                    let aesStatus = aes_ctr_crypt(cipherText!.bytes, &privateKey, Int32(privateKey.count), &counter, aes_ctr_cbuf_inc, ctx)
                    if aesStatus != EXIT_SUCCESS {
                        sendError(DecriptError.unknown, "AES Error")
                        return
                    }
                    let account = Account(privateKey: privateKey.data)
                    if !(account?.address?.isEqual(expectedAddress))!  {
                        sendError(DecriptError.invalidParameter, "address mismatched")
                        return
                    }
                    DispatchQueue.main.async {
                        if stop != 0 {
                            sendError(DecriptError.cancelled, "cancelled")
                        } else {
                          callback(account, nil)
                        }
                    }
                }
             } else {
                sendError(DecriptError.invalidJSON, "invalid json")
            }
        } catch let e {
            callback(nil, e)
        }
        return cancellable
    }
    
    public func signDigest(digest: Data) -> Signature? {
        guard digest.count == 32 else {return nil}
        var signatureData = Bytes(repeating: 0, count: 64)
        var pby: Byte = 0
        var curve = secp256k1
        ecdsa_sign_digest(&curve, self.privateKey!.bytes, digest.bytes, &signatureData, &pby, nil)
        return Signature(data: signatureData.data, v: pby)
    }
    
    public class func verifyDigest(digest: Data,signature: Signature) -> Address? {
        var publicKey = Bytes(repeating: 0, count: 65)
        var curve = secp256k1
        let status = ecdsa_verify_digest_recover(&curve, &publicKey, signature.data.bytes, digest.bytes, Int32(signature.v))
        guard status == 0 else { return nil }
        publicKey = Bytes(publicKey[1..<publicKey.count])
        let pubData = Crypto.KECCAK256(data: publicKey.data)
        let addressData = pubData[12..<pubData.count]
        return Address(data: addressData)
    }
    
    private static func getData(path: String,data: [String:Any]) -> Any? {
        let components = path.lowercased().components(separatedBy: "/")
        guard components.count > 0 else { return nil }
        var obj: Any?
        for i in 0..<components.count {
            if i == 0 {
                obj = data[components[0]]
                continue
            }
            if let data = obj as? [String:Any] {
                obj = data[components[i]]
            } else {
                return nil
            }
        }
        return obj
    }
    
    private func setPrivateKey(privateKey: Data) {
        self.privateKey = Crypto(data: privateKey).data
        var publicKey = Crypto(length: 65).data.bytes
        let privateKeyBytes = privateKey.bytes
        let curve = UnsafeMutablePointer<ecdsa_curve>.allocate(capacity: 1)
        curve.pointee = secp256k1
        ecdsa_get_public_key65(curve, privateKeyBytes, &publicKey)
        publicKey = Bytes(publicKey[1..<publicKey.count])
        let pubData = Crypto.KECCAK256(data: publicKey.data)
        let addressData = pubData[12..<pubData.count]
        self.address = Address(data: addressData)
        curve.deallocate()
    }
    
    private func mnemonic_check(mnemonicPhrase: String) -> Bool{
        var data = Bytes(repeating:0,count:1 + (512 / 8))
        let length = data_from_mnemonic(mnemonicPhrase.cString(using: String.Encoding.utf8), &data)
        memset(&data, 0, 1 + (512 / 8));
        return length > 0
    }
    
    public struct DecriptError {
        
        public static let invalidJSON = -1
        public static let unsupportedVersion = -2
        public static let unsupportedKeyDerivationFunction = -3
        public static let unsupportedCipher = -4
        public static let invalidParameter = -5
        public static let cancelled = -6
        public static let wrongPassword = -7
        public static let unknown = -8
        
    }
    
}

open class Cancellable: NSObject {
    
    private(set) var cancelled: Bool!
    private(set) var cancelCallback: (()->Void)?
    
    public override init() {
        super.init()
        self.cancelled = false
    }
    
    public convenience init(cancelCallback: (()->Void)?) {
        self.init()
        self.cancelCallback = cancelCallback
    }
    
    public func cancel() {
        if !self.cancelled && self.cancelCallback != nil {
            self.cancelled = true
            self.cancelCallback!()
        }
        
    }
    
}
