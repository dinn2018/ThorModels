//
//  Transaction.swift
//  ThorKit
//
//  Created by 丁磊 on 2018/7/30.
//  Copyright © 2018年 丁磊. All rights reserved.
//

public enum ChainTag: Byte {
    case main = 0x4a
    case test = 0x27
    case solo = 0xc7
}

let kInvalidChainTag = -1
let kInvalidBlockRef = -2
let kInvalidExpiration = -3
let kInvalidGasPriceCoef = -4
let kInvalidGas = -5
let kInvalidNonce = -6

let NullItem = rlpItem.wrapData(data: Data())

open class Transaction: NSObject {
    
    public var chainTag: ChainTag!
    public var blockRef: BlockRef!
    public var expiration: UInt32!
    public lazy var clauses = Array<Clause>()
    public var gasPriceCoef: Byte!
    public var gas: UInt64!
    public var dependsOn: Bytes32?
    public var nonce: UInt64!
    
    private var reserved = Array<rlpItem>()
    
    public var signature: Signature?
    
    open private(set) var signer: Address?

    public override init() {
        super.init()
    }
    
    public func appendClause(clause: Clause) {
        self.clauses.append(clause)
    }
    
    public func signingHash() -> Bytes32 {
        let signingData = try! RLPSerialization.encode(items: rlpItem.wrapRlpItem(items: self.signingObjs()))
        print(signingData.hexString())
        return Bytes32(data: Crypto.BLAKE2B(data: signingData))!
    }
    
    public func serialize() throws -> Data {
        do {
            var results = try self.signingObjs()
            if self.signature != nil {
                results.append(rlpItem.wrapData(data: self.signature!.sig))
            }
            return try! RLPSerialization.encode(items: rlpItem.wrapRlpItem(items: results))
        } catch let err {
            throw err
        }
    }
    
    public func ID() -> Bytes32? {
        guard self.signer != nil else { return nil }
        var data = Data(bytes: self.signingHash().data!.bytes)
        data.append(self.signer!.data!)
        return Bytes32(data: Crypto.BLAKE2B(data: data))
    }
    
    internal func sign(account: Account) {
        let signingHash = self.signingHash().data!
        self.signature = account.signDigest(digest: signingHash)
        self.signer = Account.verifyDigest(digest: signingHash, signature: self.signature!)
    }
    
    private func signingObjs() throws -> Array<rlpItem> {
        
        let check = {
            (params: Any?,errCode: Int,msg: String) throws in
            guard params != nil else {
                throw NSError(domain: "Transaction", code: errCode, userInfo: ["reason":msg])
            }
        }
        
        do {
            try check(self.chainTag, kInvalidChainTag, "chainTag cann't be nil")
            try check(self.blockRef, kInvalidBlockRef, "blockRef cann't be nil")
            try check(self.expiration, kInvalidExpiration, "expiration cann't be nil")
            try check(self.gasPriceCoef, kInvalidGasPriceCoef, "gasPriceCoef cann't be nil")
            try check(self.gas, kInvalidGas, "gas cann't be nil")
            try check(self.nonce, kInvalidNonce, "nonce cann't be nil")
        } catch let err {
            throw err
        }
        
        var result = Array<rlpItem>()
        result.append(rlpItem.wrapNumber(i: UInt64(self.chainTag.rawValue)))
        result.append(rlpItem.wrapData(data: stripDataZeros(data: self.blockRef.data)))
        result.append(rlpItem.wrapNumber(i: UInt64(self.expiration)))

        var clausesData = Array<rlpItem>()
        for clause in self.clauses {
            var clauseData = Array<rlpItem>()
            if clause.toAddress != nil {
                clauseData.append(rlpItem.wrapData(data: clause.toAddress!.data!))
            } else {
                clauseData.append(NullItem)
            }
            if clause.value != nil {
                clauseData.append(rlpItem.wrapData(data: stripDataZeros(data: clause.value!.hexString()!.hexadecimal()!)))
            } else {
                clauseData.append(NullItem)
            }
            if clause.data != nil {
                clauseData.append(rlpItem.wrapData(data: clause.data!))
            } else {
                clauseData.append(NullItem)
            }
            clausesData.append(rlpItem.wrapRlpItem(items: clauseData))
        }
        result.append(rlpItem.wrapRlpItem(items: clausesData))

        result.append(rlpItem.wrapNumber(i: UInt64(self.gasPriceCoef)))
        result.append(rlpItem.wrapNumber(i: UInt64(self.gas)))

        if self.dependsOn != nil {
            result.append(rlpItem.wrapData(data: dependsOn!.data!))
        } else {
            result.append(NullItem)
        }
        result.append(rlpItem.wrapNumber(i: self.nonce))
        result.append(rlpItem.wrapRlpItem(items: self.reserved))
        
        return result
    }
    
    private func stripDataZeros(data: Data) -> Data{
        var bytes = data.bytes
        var offset = 0
        while offset < data.count && bytes[offset] == 0 {
            offset+=1
        }
        return data[offset..<data.count]
    }
}

open class BlockRef: NSObject {
    
    open private(set) var blockNumber: UInt32!
    open private(set) var data: Data!
    
    private override init() {
        super.init()
    }
    
    public convenience init(blockNumber: UInt32) {
        self.init()
        self.blockNumber = blockNumber
        var bd = Bytes(repeating: 0, count: 8)
        bd[0] = Byte((blockNumber >> 24) & 0xFF)
        bd[1] = Byte((blockNumber >> 16) & 0xFF)
        bd[2] = Byte((blockNumber >> 8) & 0xFF)
        bd[3] = Byte(blockNumber & 0xFF)
        self.data = bd.data
    }
    
}

open class Clause: NSObject {
    
    public var toAddress: Address?
    public var value: BigNumber?
    public var data: Data?
    
    public override init() {
        super.init()
    }
    
    public convenience init(toAddress: Address?, value: BigNumber?, data: Data?) {
        self.init()
        self.toAddress = toAddress
        self.value = value
        self.data = data
    }
    
}
