//
//  extensions.swift
//  ThorKit
//
//  Created by 丁磊 on 2018/7/24.
//  Copyright © 2018年 丁磊. All rights reserved.
//

public typealias Byte = UInt8

public typealias Bytes = Array<Byte>

extension UInt64 {
    
    public func toData() -> Data {
        guard self != 0 else { return Data() }
        var bytes = Bytes(repeating: 0, count: MemoryLayout<UInt64>.size)
        var offset = MemoryLayout.size(ofValue: bytes)
        var i = self
        while i != 0 {
            offset -= 1
            bytes[offset] = Byte(i & 0xff)
            i >>= 8
        }
        return Data(bytes: Bytes(bytes[offset..<bytes.count]))
    }
    
}

extension String {
    
    public func hexadecimal() -> Data? {
        var hex = self
        if self.hasPrefix("0x") {
            hex = hex.substring(from: 2)
        }
        let regex = try! NSRegularExpression(pattern: "[0-9A-Fa-f]{1,2}", options: .caseInsensitive)
        var data = Data(capacity: hex.count / 2)
        regex.enumerateMatches(in: hex, options: .anchored, range: NSMakeRange(0, hex.count)) { (match, flags, stop) in
            let byteString = (hex as NSString).substring(with: match!.range)
            var num = Byte(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        guard data.count > 0 else { return nil }
        return data
    }
    
    public func substring(from: Int) -> String {
        guard from < self.count else {
            return ""
        }
        let start = self.index(self.startIndex, offsetBy: from)
        return String(self[start..<self.endIndex])
    }
    
    public func substring(to: Int) -> String {
        guard to > 0 else { return "" }
        let end = self.index(self.startIndex, offsetBy: to)
        return String(self[self.startIndex..<end])
    }
    
    public func stripHexZeros() -> String {
        var hex = self
        while hex.hasPrefix("0x0") && hex.count > 3 {
            hex = "0x".appending(hex.substring(from: 3))
        }
        return hex
    }
    
}

extension Array where Element == Byte {
    public var data: Data {
        get {
            return Data(bytes: self)
        }
    }
}

extension Data {
    
    public var bytes: Bytes {
        get {
            return Bytes(self)
        }
    }
    
    public func hexString() -> String {
        return "0x"+map { String(format: "%02x", $0) }
            .joined(separator: "")
    }
    
}

extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    public class func once(token: String, block:()->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
