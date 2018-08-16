//
//  AccountCollectionViewItem.swift
//  Wallet
//
//  Created by 丁磊 on 2018/8/9.
//  Copyright © 2018年 丁磊. All rights reserved.
//

import Cocoa
import ThorModels

class AccCollectionViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var addrLab: NSTextField!
    
    @IBOutlet weak var vetLab: NSTextField!
    
    @IBOutlet weak var engLab: NSTextField!
    
    var acc: Acc!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.cyan.cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if acc != nil {
            let addrHex = acc.addr!
            self.addrLab.stringValue = addrHex
                AccAPI.account(addrHex: addrHex, success: { (acc) in
                    self.vetLab.stringValue = acc.balance!
                }, failed: { (err) in
                    print(err)
                })
            
                AccAPI.account(addrHex: addrHex, success: { (acc) in
                    self.engLab.stringValue = acc.eng!
                }, failed: { (err) in
                    print(err)
                })
        }
    }
    
}
