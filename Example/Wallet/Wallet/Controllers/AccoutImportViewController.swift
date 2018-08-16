//
//  AccoutImportViewController.swift
//  Wallet
//
//  Created by 丁磊 on 2018/8/13.
//  Copyright © 2018年 丁磊. All rights reserved.
//

import Cocoa
import ThorModels

class AccoutImportViewController: NSViewController {
    
    @IBOutlet var keystoreTV: NSTextView!
    
    @IBOutlet weak var passwordTF: NSTextField!
    
    var accountImported: AccountCreatedOrImported!

    var cancellable: Cancellable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func confirm(_ sender: NSButton) {
        let json = keystoreTV.string
        if json.isEmpty {
            Utils.dialog(text: "keystore can't be empty")
            return
        }
        let password = self.passwordTF.stringValue
        if password.isEmpty {
            Utils.dialog(text: "password can't be empty")
            return
        }
        self.cancellable = Account.decryptSecretStorageJSON(json: json, password: password, callback: { (acc, error) in
            if error != nil {
                Utils.dialog(text: error!.localizedDescription)
                return
            }
            FileManager.default.createFile(atPath: Utils.JSONPath().appendingPathComponent(acc!.address!.hexString!+".json").path, contents: json.data(using: String.Encoding.utf8), attributes: nil)
            if !self.accountImported!.accountCreatedOrImported(addr: acc!.address!) {
                Utils.dialog(text: "account already exsits")
                return
            }
            self.dismissViewController(self)
        })
    }
    
    @IBAction func cancel(_ sender: NSButton) {
        if self.cancellable != nil {
            self.cancellable.cancel()
            self.cancellable = nil
        }
        self.dismissViewController(self)
    }
    
}
