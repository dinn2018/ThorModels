//
//  RegEx.swift
//  ThorKit-ios
//
//  Created by 丁磊 on 2018/7/23.
//  Copyright © 2018年 丁磊. All rights reserved.
//


open class RegEx: NSObject {
    
    var regex: NSRegularExpression?
    
    init?(pattern: String) {
        super.init()
        do {
            self.regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        }catch let e {
            print(e)
            return nil
        }
    }
    
    open func matchesAny(str: String) -> Bool {
        let range = self.regex?.rangeOfFirstMatch(in: str, options: NSRegularExpression.MatchingOptions.anchored, range: NSMakeRange(0, str.count))
        return range?.location != NSNotFound
    }
    
    open func matchesExactly(str: String) -> Bool {
         let range = self.regex?.rangeOfFirstMatch(in: str, options: NSRegularExpression.MatchingOptions.anchored, range: NSMakeRange(0, str.count))
        return range?.location == 0 && (range?.length)! == str.count
    }
    
    struct Bytes {
        
        public static let decimal = RegEx(pattern: "^-?[0-9!]*$")!
        
        public static let hex = RegEx(pattern: "^-?0x[0-9A-Fa-f!]*$")!
        
        public static let hexAddress = RegEx(pattern: "^(0x)?[0-9A-Fa-f]{40}$")!
        
    }
}
