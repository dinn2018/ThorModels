//
//  Address.swift
//  ThorKit
//
//  Created by 丁磊 on 2018/7/26.
//  Copyright © 2018年 丁磊. All rights reserved.
//

open class Address: NSObject {
    
    open private(set) var data: Data?
    open private(set) var hexString: String?
    
    override init() {
        super.init()
    }
    
    public convenience init?(data: Data) {
        guard data.count == 20 else { return nil }
        self.init()
        self.data = data
        self.hexString = data.hexString()
    }
    
    public convenience init?(hexString: String?) {
        guard hexString != nil else {
            return nil
        }
        guard RegEx.Bytes.hexAddress.matchesExactly(str: hexString!) else {
            return nil
        }
        self.init()
        if let data = Crypto(hexString: hexString!)?.data {
            self.data = data
            if hexString!.hasPrefix("0x") {
                self.hexString = hexString
            } else {
                self.hexString = "0x"+hexString!
            }
        }
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        if let obj = object as? Address {
            return self.hexString == obj.hexString
        }
        return false
    }
    
}
