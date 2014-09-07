//
//  JsonSerialize.swift
//  Json
//
//  Created by Scott Bennett on 2014-09-07.
//  Copyright (c) 2014 Scott Bennett. All rights reserved.
//

import Foundation

extension Json {
    public func serialize() -> StringType {
        switch self {
            case Null:
                return "null"
                
            case Boolean(let boolean):
                if boolean {
                    return "true"
                } else {
                    return "false"
                }
                
            case Number(let number):
                return NSString(format: "%g", number)
                
            case String(let string):
                return "\"\(string)\""
                
            case Array(let array):
                var result = "["
                for json in array {
                    result += json.serialize() + ","
                }
                result += "]"
                return result
                
            case Object(let object):
                var result = "{"
                for (key, value) in object {
                    result += "\"\(key)\":" + value.serialize() + ","
                }
                result += "}"
                return result
                
            default:
                return ""
        }
    }
    
    public func serializeToFile(filename: StringType) {
        // Unimplemented
    }
    
    public func prettyPrint(indentation: StringType = "    ", var count: Int = 0) -> StringType {
        switch self {
            case Null:
                return "null"
                
            case Boolean(let boolean):
                if boolean {
                    return "true"
                } else {
                    return "false"
                }
                
            case Number(let number):
                return NSString(format: "%g", number)
                
            case String(let string):
                return "\"\(string)\""
                
            case Array(let array):
                var result = "[\n"
                ++count
                
                for json in array {
                    result += indent(indentation, count) + json.prettyPrint(indentation: indentation, count: count) + ",\n"
                }
                
                --count
                result += indent(indentation, count) + "]"
                return result
                
            case Object(let object):
                var result = "{\n"
                ++count
                
                for (key, value) in object {
                    result += indent(indentation, count) + "\"\(key)\":" + value.prettyPrint(indentation: indentation, count: count) + ",\n"
                }
                
                --count
                result += indent(indentation, count) + "}"
                return result
                
            default:
                return ""
        }
    }
    
    public func prettyPrintToFile(filename: StringType) {
        // Unimplemented
    }
    
    private func indent(indentation: StringType, _ count: Int) -> StringType {
        var result = ""
        
        for i in 0 ..< count {
            result += indentation
        }
        
        return result
    }
}
