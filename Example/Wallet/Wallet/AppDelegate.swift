//
//  AppDelegate.swift
//  Wallet
//
//  Created by 丁磊 on 2018/8/9.
//  Copyright © 2018年 丁磊. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        Utils.createDirectoryIfNotExist()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    
}

