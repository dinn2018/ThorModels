//
//  ScureData.swift
//  ThorKit-ios
//
//  Created by 丁磊 on 2018/7/23.
//  Copyright © 2018年 丁磊. All rights reserved.
//

open class Crypto: NSObject {
    
    open var data : Data!
    
    override init() {
        self.data = Data(capacity: 0)
    }
    
    public init(capacity: Int) {
        super.init()
        self.data = Data(capacity: capacity)
    }
    
    public init(data: Data) {
        super.init()
        self.data = data
    }
    
    public init(length: Int) {
        super.init()
        self.data = Data(count: length)
        self.data.reserveCapacity(length)
    }
    
    public init?(hexString: String) {
        super.init()
        self.data = hexString.hexadecimal()
    }
    
    open func KECCAK256() {
        let ctx = UnsafeMutablePointer<SHA3_CTX>.allocate(capacity: 1)
        defer {
            ctx.deallocate()
        }
        var d = Bytes(repeating: 0, count: 32)
        sha3_256_Init(ctx)
        sha3_Update(ctx, self.data.bytes, self.data.count)
        keccak_Final(ctx, &d)
        self.data = d.data
    }
    
    open class func KECCAK256(data: Data) -> Data {
        let cryData = Crypto(data: data)
        cryData.KECCAK256()
        return cryData.data
    }
    
    open func BLAKE2B() {
        let s = UnsafeMutablePointer<blake2b_state>.allocate(capacity: 1)
        defer {
            s.deallocate()
        }
        var blake = Bytes(repeating: 0,count: 32)
        blake2b_init(s, 32)
        blake2b_update(s, self.data.bytes, self.data.count)
        blake2b_final(s, &blake, 32)
        self.data = Data(bytes: blake)
    }
    
    open class func BLAKE2B(data: Data) -> Data {
        let cryData = Crypto(data: data)
        cryData.BLAKE2B()
        return cryData.data
    }
    func subdataFromIndex(fromIndex: Int) -> Data {
        return self.subdataWithRange(range: Range(NSMakeRange(fromIndex, self.data.count-fromIndex))!)
    }
    func subdataWithRange(range: Range<Data.Index>) -> Data {
        return self.data.subdata(in: range)
    }
    
}


