//
//  Bytes32.swift
//  ThorKit
//
//  Created by 丁磊 on 2018/7/30.
//  Copyright © 2018年 丁磊. All rights reserved.
//

open class Bytes32: NSObject {
    
    open private(set) var data: Data?
    open private(set) var hexString: String?
    
    override init() {
        super.init()
    }
    
    public convenience init?(data: Data) {
        guard data.count == 32 else { return nil }
        self.init()
        self.data = data
        self.hexString = data.hexString()
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        if let obj = object as? Bytes32 {
            return self.hexString == obj.hexString
        }
        return false
    }
    
}
