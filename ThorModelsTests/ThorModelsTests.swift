//
//  ThorModels_iOSTests.swift
//  ThorModels_iOSTests
//
//  Created by 丁磊 on 2018/8/16.
//  Copyright © 2018年 丁磊. All rights reserved.
//

import XCTest
@testable import ThorModels

class ThorModelsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddress() {
        let addrHex = "0x0000000000000000000000000000456e65726779"
        let addrData = addrHex.hexadecimal()
        XCTAssertNotNil(addrData)
        
        let addr = Address(hexString: addrHex)
        XCTAssert(addrHex == addr?.hexString)
        XCTAssert(addrData == addr?.data)
        
        let addr1 = Address(data: addrData!)
        XCTAssert(addrHex == addr1?.hexString)
        XCTAssert(addrData == addr1?.data)
        
    }
    
    func testAccount() {
        //create a random account
        let account = Account.randomMnemonicAccount()
        XCTAssertNotNil(account)
        XCTAssertNotNil(account?.privateKey)
        XCTAssertNotNil(account?.address)
        XCTAssertNotNil(account?.mnemonicPhrase)
        XCTAssertNotNil(account?.mnemonicData)
        
        //create a account from mnemonicPhrase
        let acc = Account(mnemonicPhrase: account!.mnemonicPhrase!)
        XCTAssert(account?.privateKey == acc?.privateKey)
        XCTAssert(account?.address == acc?.address)
        XCTAssert(account?.mnemonicData == acc?.mnemonicData)
        XCTAssert(account?.mnemonicPhrase == acc?.mnemonicPhrase)
        
        //create a account from privateKey
        let acc1 = Account(privateKey: account!.privateKey!)
        XCTAssert(account?.privateKey == acc1?.privateKey)
        XCTAssert(account?.address == acc1?.address)
        XCTAssertNil(acc1?.mnemonicPhrase)
        XCTAssertNil(acc1?.mnemonicData)
        
        //encrypt account and decrypt account
        let password = "password"
        _ = account?.encryptSecretStorageJSON(password: password, callback: { (json, err) in
            XCTAssertNil(err)
            XCTAssertNotNil(json)
            
            _ = Account.decryptSecretStorageJSON(json: json!, password: password, callback: { (acc, err) in
                XCTAssertNil(err)
                XCTAssertNotNil(acc)
                
                XCTAssert(account?.privateKey == acc?.privateKey)
                XCTAssert(account?.address == acc?.address)
                XCTAssertNil(account?.mnemonicPhrase)
                XCTAssertNil(account?.mnemonicData)
            })
            
        })
    }
    
    
}
