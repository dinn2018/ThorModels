//
//  BigNumber.swift
//  ThorKit
//
//  Created by 丁磊 on 2018/7/24.
//  Copyright © 2018年 丁磊. All rights reserved.
//


open class BigNumber: NSObject {
    
    private var bigNumber: UnsafeMutablePointer<mp_int>!
    
    public override init() {
        super.init()
        self.mpInit()
    }
    
    convenience public init(integer: Int) {
        self.init()
        self.mpReadRadix(str: String(integer), radix: 10)
    }
    
    public convenience init(data: Data) {
        self.init()
        self.mpReadRadix(str: data.hexString(), radix: 16)
    }
    
    public convenience init?(decimalString: String) {
        guard RegEx.Bytes.decimal.matchesExactly(str: decimalString) else { return nil }
        self.init()
        self.mpReadRadix(str: decimalString, radix: 10)
    }
    
    public convenience init?(hexString: String) {
        guard RegEx.Bytes.hex.matchesExactly(str: hexString) else { return nil}
        self.init()
        var h: String
        if hexString.hasPrefix("-") {
            h = "-"+hexString.substring(from: 3)
        }else {
            h = hexString.substring(from: 2)
        }
        self.mpReadRadix(str: h, radix: 16)

    }
    
    open func add(other: BigNumber) -> BigNumber {
        let result = BigNumber()
        mp_add(self.bigNumber, other.bigNumber, result.bigNumber)
        return result
    }
    
    open func sub(other: BigNumber) -> BigNumber {
        let result = BigNumber()
        mp_sub(self.bigNumber, other.bigNumber, result.bigNumber)
        return result
    }
    
    open func mul(other: BigNumber) -> BigNumber {
        let result = BigNumber()
        mp_mul(self.bigNumber, other.bigNumber, result.bigNumber)
        return result
    }
    
    open func div(other: BigNumber) -> BigNumber {
        let result = BigNumber()
        mp_div(self.bigNumber, other.bigNumber, result.bigNumber, nil)
        return result
    }
    
    open func mod(other: BigNumber) -> BigNumber {
        let result = BigNumber()
        mp_div(self.bigNumber, other.bigNumber, nil, result.bigNumber)
        return result
    }
    
    open func formatString(radix: Int32) -> String? {
        var radixSize = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
        defer {
            radixSize.deallocate()
        }
        
        mp_radix_size(self.bigNumber, radix, radixSize)
        
        var result = [Int8](repeating: 0, count: Int(radixSize.pointee))
        
        mp_toradix(self.bigNumber, &result, radix)
        
        return String(cString: result, encoding: String.Encoding.ascii)
    }
    
    open func decimalString() -> String? {
        return self.formatString(radix: 10)
    }
    
    open func hexString() -> String? {
        
        var hex = self.formatString(radix: 16)
        
        guard hex != nil else { return nil }
        
        if self.isNegative() {
            let from = hex!.index(hex!.startIndex, offsetBy: 1)
            hex = String(hex![from..<hex!.endIndex])
        }
        
        if hex!.count % 2 != 0 {
            hex = "0" + hex!
        }
        
        if self.isNegative() {
            hex = "-" + hex!
        }
        
        return "0x" + hex!
    }

    open func compare(other: BigNumber) -> ComparisonResult {
        let result = mp_cmp(self.bigNumber, other.bigNumber)
        switch result {
        case MP_EQ:
            return .orderedSame
        case MP_LT:
            return .orderedAscending
        default:
            return .orderedDescending
        }
    }
    
    open func lessThan(other: BigNumber) -> Bool {
        let result = mp_cmp(self.bigNumber, other.bigNumber)
        return result == MP_LT
    }
    
    open func lessThanEqualTo(other: BigNumber) -> Bool {
        let result = mp_cmp(self.bigNumber, other.bigNumber)
        return (result == MP_LT || result == MP_EQ)
    }
    
    open func greaterThan(other: BigNumber) -> Bool {
        let result = mp_cmp(self.bigNumber, other.bigNumber)
        return result == MP_GT
    }
    
    open func greaterThanEqualTo(other: BigNumber) -> Bool {
        let result = mp_cmp(self.bigNumber, other.bigNumber)
        return (result == MP_GT || result == MP_EQ)
    }
    
    open func isNegative() -> Bool {
        return self.bigNumber.pointee.sign == MP_NEG
    }
    
    private func mpReadRadix(str: String,radix: Int32) {
        mp_read_radix(self.bigNumber, str.cString(using: String.Encoding.ascii), radix)
    }
    
    private func mpInit() {
        self.bigNumber = UnsafeMutablePointer<mp_int>.allocate(capacity: 1)
        mp_init(self.bigNumber)
    }
    
    deinit {
        mp_clear(self.bigNumber)
    }
    
    public struct Constant{
        
        public static var NegativeOne: BigNumber {
            get {
                return BigNumber(integer: -1)
            }
        }
        
        public static var Zero: BigNumber {
            get {
                return BigNumber(integer: 0)
            }
        }
        
        public static var One: BigNumber {
            get {
                return BigNumber(integer: 1)
            }
        }
        
        public static var MaxUInt64: BigNumber {
            get {
                return BigNumber(hexString: "0xffffffffffffffff")!
            }
        }
        
    }
    
}
