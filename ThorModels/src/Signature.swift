//
//  Signature.swift
//  ThorKit
//
//  Created by 丁磊 on 2018/7/30.
//  Copyright © 2018年 丁磊. All rights reserved.
//

open class Signature: NSObject {
    
    open private(set) var data: Data!
    open private(set) var v: UInt8!
    open private(set) var sig: Data!
    
    override init() {
        super.init()
    }
    
    public convenience init?(data: Data,v: UInt8) {
        guard data.count == 64 else {return nil}
        self.init()
        self.data = data
        self.v = v
        var d = Data(bytes: data.bytes)
        d.append(v)
        self.sig = d
    }
    
    public convenience init?(sig: Data) {
        guard sig.count == 65 else { return nil }
        self.init()
        self.data = Bytes(sig[0..<64]).data
        self.v = sig.last!
        self.sig = sig
    }
}
