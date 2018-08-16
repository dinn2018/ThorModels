//
//  ViewController.swift
//  Wallet
//
//  Created by 丁磊 on 2018/8/9.
//  Copyright © 2018年 丁磊. All rights reserved.
//

import Cocoa
import ThorModels

class MainViewController: NSViewController,NSCollectionViewDelegate,NSCollectionViewDataSource,AccountCreatedOrImported {
    
    @IBOutlet weak var accsCollectionView: NSCollectionView!
    
    var accs = [Acc]()
    
    let itemID = "AccCollectionViewItem"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accsCollectionView.dataSource = self
        accsCollectionView.delegate = self
        accsCollectionView.register(NSNib(nibNamed: NSNib.Name(rawValue: itemID), bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: itemID))
        
        readJSONFiles()
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(MainViewController.reload), userInfo: nil, repeats: true)
    }
    
    @objc func reload() {
        self.accsCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.accs.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        var accountCollectionViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: itemID), for: indexPath) as? AccCollectionViewItem
        if accountCollectionViewItem == nil {
            accountCollectionViewItem = AccCollectionViewItem(nibName: NSNib.Name(rawValue: itemID), bundle: Bundle.main)
        }
        accountCollectionViewItem?.acc = self.accs[indexPath.item]
        return accountCollectionViewItem!
    }
    
    @IBAction func createAccount(_ sender: NSButton) {
        let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "AccountCreationViewController"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "AccountCreationViewController")) as! AccountCreationViewController
        vc.accountCreation = self
        self.presentViewControllerAsSheet(vc)
    }
    
    @IBAction func importAccount(_ sender: NSButton) {
        print("importAcc")
        let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "AccoutImportViewController"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "AccoutImportViewController")) as! AccoutImportViewController
        vc.accountImported = self
        self.presentViewControllerAsSheet(vc)
    }
    
    func readJSONFiles() {
        let url = Utils.JSONPath()
        let fileManager = FileManager.default
        do {
            let jsonURLs = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            for jsonURL in jsonURLs {
                let data = try Data(contentsOf: jsonURL, options: Data.ReadingOptions.alwaysMapped)
                let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any?]
                if dict != nil {
                    if let addrHex = dict!["address"] {
                        if let addr = Address(hexString: addrHex as? String) {
                            let acc = Acc(addr: addr.hexString, balance: "0", eng: "0")
                            self.accs.append(acc)
                        }
                    }
                }
            }
        } catch let e {
            print(e)
        }
    }
    
    
    func accountCreatedOrImported(addr: Address) -> Bool{
        let filterAddrs = self.accs.filter { (a) -> Bool in
            return a.addr == addr.hexString
        }
        guard filterAddrs.count == 0 else { return false}
        let acc = Acc(addr: addr.hexString, balance: "0", eng: "0")
        self.accs.append(acc)
        self.accsCollectionView.reloadItems(at: Set<IndexPath>(arrayLiteral: IndexPath(item: self.accs.count-1, section: 0)))
        return true
    }
}

