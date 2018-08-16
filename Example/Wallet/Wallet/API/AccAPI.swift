//
//  AccountsAPI.swift
//  Wallet
//
//  Created by 丁磊 on 2018/8/13.
//  Copyright © 2018年 丁磊. All rights reserved.
//

import Cocoa
import Alamofire
import ThorModels

class AccAPI: NSObject {
    
    static let host = "http://127.0.0.1:8669/"
    
    class func account(addrHex: String,success: @escaping (_ acc: Acc)->Void,failed: @escaping (_ error: Error)->Void) {
        Alamofire.request(host+"accounts/"+addrHex).responseData(queue: DispatchQueue.main) { (res) in
            do {
                let data = res.data
                let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                let balance = Utils.format(hexString: dic["balance"] as! String)
                let energy = Utils.format(hexString: dic["energy"] as! String)
                let acc = Acc(addr: addrHex, balance: balance, eng: energy)
                success(acc)
            } catch let err {
                failed(err)
            }
        }
    }
    
}
