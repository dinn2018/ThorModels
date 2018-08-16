//
//  Account.swift
//  Wallet
//
//  Created by 丁磊 on 2018/8/13.
//  Copyright © 2018年 丁磊. All rights reserved.
//

import Cocoa

class Acc: NSObject {
    
    var addr: String?
    var balance: String?
    var eng: String?
    
    override init() {
        super.init()
    }
    
    convenience init(addr: String?,balance: String?,eng: String?) {
        self.init()
        self.addr = addr
        self.balance = balance
        self.eng = eng
    }
}
