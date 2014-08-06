//
//  JsonParser.swift
//  Json
//
//  Created by Scott Bennett on 2014-08-03.
//  Copyright (c) 2014 Scott Bennett. All rights reserved.
//

import Foundation

extension Json {
    private typealias UnicodeString = StringType.UnicodeScalarView
    private typealias UnicodeStringIndex = UnicodeString.Index
    
    public static func parse(json: StringType) -> Json? {
        let unicodeString = json.unicodeScalars
        var index = unicodeString.startIndex
        return parse(unicodeString, index: &index)
    }
    
    private static func parse(contents: UnicodeString, inout index: UnicodeStringIndex) -> Json? {
        skipWhitespace(contents, index: &index)
        
        switch contents[index].value {
            case let c where isnumber(Int32(c)) != 0 || c == UnicodeScalarValue("."):
                return parseNumber(contents, index: &index)
                
            case UnicodeScalarValue("n"), UnicodeScalarValue("f"), UnicodeScalarValue("t"):
                return parseConstant(contents, index: &index)
                
            case UnicodeScalarValue("\""):
                return parseString(contents, index: &index)
                
            case UnicodeScalarValue("["):
                return parseArray(contents, index: &index)
                
            case UnicodeScalarValue("{"):
                return parseObject(contents, index: &index)
                
            default:
                break
        }
        
        return nil
    }
    
    private static func skipWhitespace(contents: UnicodeString, inout index: UnicodeStringIndex) {
        while isspace(Int32(contents[index].value)) != 0 {
            index = index.successor()
        }
    }
    
    private static func parseConstant(contents: UnicodeString, inout index: UnicodeStringIndex) -> Json? {
        let start = index
        var c = contents[index].value
        
        switch c {
            case UnicodeScalarValue("n"):
                index = advance(index, 4)
                if Swift.String(contents[start..<index]) == "null" && isalnum(Int32(contents[index].value)) == 0 {
                    return .Null
                }
                
            case UnicodeScalarValue("f"):
                index = advance(index, 5)
                if Swift.String(contents[start..<index]) == "false" && isalnum(Int32(contents[index].value)) == 0 {
                    return .Boolean(false)
                }
                
            case UnicodeScalarValue("t"):
                index = advance(index, 4)
                if Swift.String(contents[start..<index]) == "true" && isalnum(Int32(contents[index].value)) == 0 {
                    return .Boolean(true)
                }
                
            default:
                break
        }
        
        return nil
    }
    
    private static func parseNumber(contents: UnicodeString, inout index: UnicodeStringIndex) -> Json? {
        var c = contents[index].value
        
        if isnumber(Int32(c)) != 0 || c == UnicodeScalarValue(".") {
            var result: CDouble = 0
            
            while isnumber(Int32(c)) != 0 {
                // Increase the value
                result *= 10
                result += CDouble(c - UnicodeScalarValue("0"))
                
                // Get the next character
                index = index.successor()
                c = contents[index].value
            }
            
            if c == UnicodeScalarValue(".") {
                // Skip the decimal place
                index = index.successor()
                c = contents[index].value
                
                var exponent: CDouble = 1
                
                while isnumber(Int32(c)) != 0 {
                    // Increase the value
                    exponent *= 0.1
                    result += exponent * CDouble(c - UnicodeScalarValue("0"))
                    
                    // Get the next character
                    index = index.successor()
                    c = contents[index].value
                }
            }
            
            // Make sure there aren't any other additional characters following the number
            if isalnum(Int32(c)) == 0 {
                return .Number(result)
            }
        }
        
        return nil
    }
    
    private static func parseString(contents: UnicodeString, inout index: UnicodeStringIndex) -> Json? {
        var result = ""
        var c = contents[index].value
        
        if c == UnicodeScalarValue("\"") {
            // Ignore the start quote
            index = index.successor()
            let start = index
            c = contents[index].value
            
            while c != UnicodeScalarValue("\"") {
                // Check if the character is unrepresentable in unicode (like the end of the string)
                if c == 65533 {
                    return nil
                }
                
                if c == UnicodeScalarValue("\\") {
                    // Get the next character
                    index = index.successor()
                    c = contents[index].value
                    
                    switch c {
                        case UnicodeScalarValue("n"):  result += "\n"
                        case UnicodeScalarValue("t"):  result += "\t"
                        case UnicodeScalarValue("\\"): result += "\\"
                        case UnicodeScalarValue("\""): result += "\""
                        default: result += Character(UnicodeScalar(c))
                    }
                } else {
                    result += Character(UnicodeScalar(c))
                }
                
                // Get the next character
                index = index.successor()
                c = contents[index].value
            }
            
            // Make sure the string ends correctly
            if c == UnicodeScalarValue("\"") {
                // Ignore the end quote
                index = index.successor()
            } else {
                return nil
            }
            
            return .String(result)
        }
        
        return nil
    }
    
    private static func parseArray(contents: UnicodeString, inout index: UnicodeStringIndex) -> Json? {
        var result: [Json] = []
        var c = contents[index].value
        
        if c == UnicodeScalarValue("[") {
            // Ignore the start square bracket
            index = index.successor()
            
            // Skip possible whitespace between the first bracket and anything else
            skipWhitespace(contents, index: &index)
            c = contents[index].value
            
            if c != UnicodeScalarValue("]") {
                // Parse the first value in the array
                if let member = parse(contents, index: &index) {
                    result.append(member)
                } else {
                    return nil
                }
                
                skipWhitespace(contents, index: &index)
                c = contents[index].value
                
                // Continue adding elements to the array as long as there are more commas
                while c == UnicodeScalarValue(",") {
                    // Ignore the comma
                    index = index.successor()
                    
                    if let member = parse(contents, index: &index) {
                        result.append(member)
                    } else {
                        return nil
                    }
                    
                    // Get the next character
                    skipWhitespace(contents, index: &index)
                    c = contents[index].value
                }
                
                // Make sure the array ends correctly
                if c == UnicodeScalarValue("]") {
                    // Ignore the end square bracket
                    index = index.successor()
                } else {
                    return nil
                }
            }
            
            return .Array(result)
        }
        
        return nil
    }
    
    private static func parseObject(contents: UnicodeString, inout index: UnicodeStringIndex) -> Json? {
        var result: [StringType : Json] = [:]
        var c = contents[index].value
        
        if c == UnicodeScalarValue("{") {
            // Ignore the start curly bracket
            index = index.successor()
            
            // Skip possible whitespace between the first bracket and anything else
            skipWhitespace(contents, index: &index)
            c = contents[index].value
            
            if c != UnicodeScalarValue("}") {
                // Parse the first value in the array
                if let (key, value) = parseMember(contents, index: &index) {
                    result[key] = value
                } else {
                    return nil
                }
                
                skipWhitespace(contents, index: &index)
                c = contents[index].value
                
                // Continue adding elements to the array as long as there are more commas
                while c == UnicodeScalarValue(",") {
                    // Ignore the comma
                    index = index.successor()
                    skipWhitespace(contents, index: &index)
                    
                    if let (key, value) = parseMember(contents, index: &index) {
                        result[key] = value
                    } else {
                        return nil
                    }
                    
                    // Get the next character
                    skipWhitespace(contents, index: &index)
                    c = contents[index].value
                }
                
                // Make sure the object ends correctly
                if c == UnicodeScalarValue("}") {
                    // Ignore the end curly bracket
                    index = index.successor()
                } else {
                    return nil
                }
            }
            
            return .Object(result)
        }
        
        return nil
    }
    
    private static func parseMember(contents: UnicodeString, inout index: UnicodeStringIndex) -> (StringType, Json)? {
        if let key = parseString(contents, index: &index)?.string {
            
            // Get the next character
            skipWhitespace(contents, index: &index)
            let c = contents[index].value
            
            if c == UnicodeScalarValue(":") {
                // Ignore the colon
                index = index.successor()
                
                if let value = parse(contents, index: &index) {
                    return (key, value)
                }
            }
        }
        
        return nil
    }
}
