//
//  JsonUtility.swift
//  Json
//
//  Created by Scott Bennett on 2014-08-03.
//  Copyright (c) 2014 Scott Bennett. All rights reserved.
//

import Foundation

extension Json: Printable, Equatable {
    public var description: StringType {
    get {
        switch self {
        case .Null:
            return "null"
            
        case .Boolean(let value):
            return "\(value)"
            
        case .Number(let value):
            return "\(value)"
            
        case .String(let value):
            return "\"\(value)\""
            
        case .Array(let value):
            return "\(value)"
            
        case .Object(let value):
            return "\(value)"
            
        default:
            return "error"
        }
    }
    }
}

@infix public func == (a: Json, b: Json) -> Bool {
    switch (a, b) {
    case (.Null, .Null):
        return true
        
    case (.Boolean(let aValue), .Boolean(let bValue)):
        return aValue == bValue
        
    case (.Number(let aValue), .Number(let bValue)):
        return aValue == bValue
        
    case (.String(let aValue), .String(let bValue)):
        return aValue == bValue
        
    case (.Array(let aValue), .Array(let bValue)):
        return aValue == bValue
        
    case (.Object(let aValue), .Object(let bValue)):
        return aValue == bValue
        
    default:
        return false
    }
}
