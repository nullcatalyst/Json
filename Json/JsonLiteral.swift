//
//  JsonLiteral.swift
//  Json
//
//  Created by Scott Bennett on 2014-08-03.
//  Copyright (c) 2014 Scott Bennett. All rights reserved.
//

import Foundation

extension Json: NilLiteralConvertible {
    public static func convertFromNilLiteral() -> Json {
        return .Null
    }
}

extension Json: BooleanLiteralConvertible {
    public static func convertFromBooleanLiteral(value: BooleanLiteralType) -> Json {
        return .Boolean(value)
    }
}

extension Json: IntegerLiteralConvertible {
    public static func convertFromIntegerLiteral(value: IntegerLiteralType) -> Json {
        return .Number(CDouble(value))
    }
}

extension Json: FloatLiteralConvertible {
    public static func convertFromFloatLiteral(value: FloatLiteralType) -> Json {
        return .Number(value)
    }
}

extension Json: StringLiteralConvertible {
    public static func convertFromStringLiteral(value: StringLiteralType) -> Json {
        return .String(value)
    }
    
    public static func convertFromExtendedGraphemeClusterLiteral(value: StringLiteralType) -> Json {
        return .String(value)
    }
}

extension Json: ArrayLiteralConvertible {
    public static func convertFromArrayLiteral(elements: Json...) -> Json {
        return .Array(elements)
    }
}

extension Json: DictionaryLiteralConvertible {
    public static func convertFromDictionaryLiteral(elements: (Swift.String, Json)...) -> Json {
        var members: [StringType : Json] = [:]
        for element in elements {
            members[element.0] = element.1
        }
        return .Object(members)
    }
}
