//
//  AccountCreationViewController.swift
//  Wallet
//
//  Created by 丁磊 on 2018/8/10.
//  Copyright © 2018年 丁磊. All rights reserved.
//

import Cocoa
import ThorModels

protocol AccountCreatedOrImported {
    func accountCreatedOrImported(addr: Address)-> Bool
}

class AccountCreationViewController: NSViewController {
    
    @IBOutlet weak var passwordTF: NSTextField!
    
    var accountCreation: AccountCreatedOrImported!
    var cancellable: Cancellable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
    }
    
    @IBAction func cancel(_ sender: NSButton) {
        if self.cancellable != nil {
            self.cancellable.cancel()
            self.cancellable = nil
        }
        self.dismissViewController(self)
    }
    
    @IBAction func confirm(_ sender: NSButton) {
        if self.passwordTF.stringValue.isEmpty {
            Utils.dialog(text: "password can't be empty")
            return
        }
        let acc = Account.randomMnemonicAccount()!
        self.cancellable = acc.encryptSecretStorageJSON(password: self.passwordTF.stringValue, callback: { (json, err) in
            if err != nil {
                DispatchQueue.main.async {
                    Utils.dialog(text: "unhandled error:"+err.debugDescription)
                }
                return
            }
            FileManager.default.createFile(atPath: Utils.JSONPath().appendingPathComponent(acc.address!.hexString!+".json").path, contents: json?.data(using: String.Encoding.utf8), attributes: nil)
            if self.accountCreation != nil {
                if !self.accountCreation!.accountCreatedOrImported(addr: acc.address!) {
                    Utils.dialog(text: "account already exsits")
                    return
                }
            }
            self.dismissViewController(self)
        })
    }
    
    
    
    
}
