//
//  Utils.swift
//  Wallet
//
//  Created by 丁磊 on 2018/8/10.
//  Copyright © 2018年 丁磊. All rights reserved.
//

import Cocoa
import ThorModels
class Utils: NSObject {
    
    static func createDirectoryIfNotExist() {
        do {
            let fileManager = FileManager.default
            let paths = fileManager.urls(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.allDomainsMask)
            let path = paths[0].absoluteURL.appendingPathComponent("ThorWallets")
            try fileManager.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        } catch let e {
            print(e)
        }
    }
    
    static func JSONPath() -> URL {
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.allDomainsMask)
        let url = paths[0].absoluteURL.appendingPathComponent("ThorWallets")
        
        return url
    }
    
    static func dialog(text: String) {
        let alert = NSAlert()
        alert.messageText = text
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    static let big18 = BigNumber(decimalString: "1000000000000000000")!
    static let big13 = BigNumber(decimalString: "10000000000000")!
    static let big0 = BigNumber(decimalString: "0")!

    static func format(hexString: String) -> String {
        let bNum = BigNumber(hexString: hexString)!
        let hNum = bNum.div(other: big18)
        let h = hNum.decimalString()!
        let m = bNum.mod(other: big18)
        let s = m.div(other: big13)
        if s.decimalString() == big0.decimalString() {
            return h
        }
        var s5 = Array(s.decimalString()!)
        while (s5.count < 5) {
            s5.insert("0", at: 0)
        }
        for i in 0..<s5.count {
            let index = s5.count-i-1
            if s5[index] != "0" {
                return h+"."+s5[0...index]
            }
        }
        return h

    }
}
