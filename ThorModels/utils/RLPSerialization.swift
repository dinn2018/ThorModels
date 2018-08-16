//
//  RLPSerialization.swift
//  ThorKit
//
//  Created by 丁磊 on 2018/7/25.
//  Copyright © 2018年 丁磊. All rights reserved.
//

let RLPSerializationErrorDomain =  "RLPCoderError"

open class RLPSerialization: NSObject {
    
    public struct Errors {
        public static let encode: Int = -1
        public static let decode: Int = -2
    }
    
    open class func encode(items: rlpItem) throws -> Data{
        if let obj = items.bytes {
            let data = obj.data
            if data.count == 1 && data[0] <= 0x7f {
                return data
            } else if data.count <= 55 {
                var result = Data(capacity: 1 + data.count)
                result.append(Byte(0x80 + data.count))
                result.append(data)
                return result
            } else {
                let lengthData = UInt64(data.count).toData()
                var result = Data(capacity: 1 + lengthData.count + data.count)
                result.append(Byte(0xb7 + lengthData.count))
                result.append(lengthData)
                result.append(data)
                return result
            }
        } else if let objs = items.items {
            var payload = Data()
            for obj in objs {
                do {
                    let encodeData = try RLPSerialization.encode(items: obj)
                    payload.append(encodeData)
                } catch let e {
                    throw e
                }
            }
            if payload.count <= 55 {
                var result = Data(capacity: 1 + payload.count)
                result.append(Byte(0xc0 + payload.count))
                result.append(payload)
                return result
            } else {
                let lengthData = UInt64(payload.count).toData()
                var result = Data(capacity: 1 + lengthData.count + payload.count)
                result.append(Byte(0xf7 + lengthData.count))
                result.append(lengthData)
                result.append(payload)
                return result
            }
        } else {
            throw NSError(domain: RLPSerializationErrorDomain, code: RLPSerialization.Errors.encode, userInfo: [
                                                    "reason": "invalid object",
                                                ])
        }
    }
    
    private class func decode(data: Data,offset: Int,consumed: UnsafeMutablePointer<Int>) -> Any? {
        guard data.count != 0 else { return nil }
        var bytes = data.bytes
        if bytes[offset] >= 0xf8 {
            let lengthLength = Int(bytes[offset] - 0xf7)
            if offset+1+lengthLength > data.count {
                consumed.pointee = -1
                return nil
            }
            let length = self.convertDataToInteger(data: data, offset: offset+1, length: lengthLength)
            if offset+1+lengthLength+length > data.count {
                consumed.pointee = -1
                return nil
            }
            var result = Array<Any>()
            var childOffset = offset+1+lengthLength
            while childOffset < offset + 1 + lengthLength + length {
                var childConsumed = 0
                let child = self.decode(data: data, offset: childOffset, consumed: &childConsumed)
                if child == nil || childConsumed == -1 {
                    consumed.pointee = -1
                    return nil
                }
                result.append(child!)
                childOffset += childConsumed
                if childOffset > offset + 1 + lengthLength + length {
                    consumed.pointee = -1
                    return nil
                }
            }
            consumed.pointee = 1 + lengthLength + length
            return result
        } else if bytes[offset] >= 0xc0 {
            let length = Int(bytes[offset] - 0xc0)
            if offset + 1 + length > data.count {
                consumed.pointee = -1
                return nil
            }
            var result = Array<Any>()
            var childOffset = offset + 1
            while childOffset < offset + 1 + length {
                var childConsumed = 0
                let child = self.decode(data: data, offset: childOffset, consumed: &childConsumed)
                if child == nil || childConsumed == -1 {
                    consumed.pointee = -1
                    return nil
                }
                result.append(child!)
                childOffset += childConsumed
                if childOffset > offset + 1 + length {
                    consumed.pointee = -1
                    return nil
                }
            }
            consumed.pointee = 1 + length
            return result
        } else if bytes[offset] >= 0xb8 {
            let lengthLength = Int(bytes[offset] - 0xb7)
            if offset + 1 + lengthLength > data.count {
                consumed.pointee = -1
                return nil
            }
            let length = self.convertDataToInteger(data: data, offset: offset+1, length: lengthLength)
            if offset + 1 + lengthLength + length > data.count {
                consumed.pointee = -1
                return nil
            }
            var result = Data(capacity: length)
            let start = Int(bytes[offset] - 0xb7)
            result.append(data[start..<length])
        } else if bytes[offset] >= 0x80 {
            let length = Int(bytes[offset] - 0x80)
            if offset + 1 + length > data.count {
                consumed.pointee = -1
                return nil
            }
            var result = Data(capacity: length)
            let start = Int(offset + 1)
            result.append(data[start..<length])
            return result
        }
        var result = Data(capacity: 1)
        result.append(bytes[offset])
        consumed.pointee = 1
        return result
    }
    
    private class func convertDataToInteger(data: Data,offset: Int,length: Int) -> Int{
        var bytes = data.bytes
        var result = 0
        for i in 0..<length {
            result <<= 8
            result += Int(bytes[offset + i])
        }
        return result
    }
    
    open class func decode(data: Data) throws -> Any? {
        var consumed = 0
        let result = self.decode(data: data, offset: 0, consumed: &consumed)
        guard consumed == data.count else { return nil }
        return result
    }
    
}

public struct rlpItem {
    
    public let valueType: ValueType
    
    public enum ValueType {
        
        case bytes(Bytes)
        
        case array([rlpItem])
    }
    
    public var bytes: Bytes? {
        guard case .bytes(let value) = valueType else {
            return nil
        }
        return value
    }
    
    public var items: [rlpItem]? {
        guard case .array(let value) = valueType else {
            return nil
        }
        return value
    }
    
    public init(valueType: ValueType) {
        self.valueType = valueType
    }
    
    public static func wrapNumber(i: UInt64) -> rlpItem {
        return rlpItem(valueType: rlpItem.ValueType.bytes(i.toData().bytes))
    }
    
    public static func wrapData(data: Data) -> rlpItem {
        return rlpItem(valueType: rlpItem.ValueType.bytes(data.bytes))
    }
    
    public static func wrapRlpItem(items: Array<rlpItem>) -> rlpItem {
        return rlpItem(valueType: rlpItem.ValueType.array(items))
    }
    
}
