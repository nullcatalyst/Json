//
//  Json.swift
//  Json
//
//  Created by Scott Bennett on 2014-08-03.
//  Copyright (c) 2014 Scott Bennett. All rights reserved.
//

import Foundation

public enum Json {
    public typealias BooleanType = Bool
    public typealias IntegerType = Int
    public typealias NumberType  = Double
    public typealias StringType  = Swift.String
    public typealias ArrayType   = [Json]
    public typealias ObjectType  = [StringType : Json]
    
    case Null
    case Boolean(BooleanType)
    case Number(NumberType)
    case String(StringType)
    case Array(ArrayType)
    case Object(ObjectType)
    
    public var boolean: BooleanType? {
        get {
            switch self {
                case .Boolean(let value):
                    return value
                    
                default:
                    return nil
            }
        }
        set {
            if let value = newValue {
                self = .Boolean(value)
            } else {
                self = .Null
            }
        }
    }
    
    public var integer: IntegerType? {
        get {
            switch self {
                case .Number(let value):
                    return IntegerType(value)
                    
                default:
                    return nil
            }
        }
        set {
            if let value = newValue {
                self = .Number(NumberType(value))
            } else {
                self = .Null
            }
        }
    }
    
    public var number: NumberType? {
        get {
            switch self {
                case .Number(let value):
                    return value
                    
                default:
                    return nil
            }
        }
        set {
            if let value = newValue {
                self = .Number(value)
            } else {
                self = .Null
            }
        }
    }
    
    public var string: StringType? {
        get {
            switch self {
                case .String(let value):
                    return value
                    
                default:
                    return nil
            }
        }
        set {
            if let value = newValue {
                self = .String(value)
            } else {
                self = .Null
            }
        }
    }
    
    public var array: ArrayType? {
        get {
            switch self {
                case .Array(let array):
                    return array
                    
                default:
                    return nil
            }
        }
        set {
            if let array = newValue {
                self = .Array(array)
            } else {
                self = .Null
            }
        }
    }
    
    public var object: ObjectType? {
        get {
            switch self {
                case .Object(let object):
                    return object
                    
                default:
                    return nil
            }
        }
        set {
            if let object = newValue {
                self = .Object(object)
            } else {
                self = .Null
            }
        }
    }
    
    public subscript(index: Int) -> Json? {
        get {
            switch self {
                case .Array(let array):
                    if index >= 0 && index < array.count {
                        return array[index]
                    } else {
                        return nil
                    }
                    
                default:
                    return nil
            }
        }
        set {
            switch self {
                case .Array(var array):
                    if let value = newValue {
                        if index >= 0 && index < array.count {
                            array[index] = value
                        }
                    } else {
                        array.removeAtIndex(index)
                    }
                    self = .Array(array)
                    
                default:
                    break
            }
        }
    }
    
    public subscript(name: StringType) -> Json? {
        get {
            switch self {
                case .Object(let object):
                    return object[name]
                    
                default:
                    return nil
            }
        }
        set {
            switch self {
                case .Object(var object):
                    if let value = newValue {
                        object[name] = value
                    } else {
                        object.removeValueForKey(name)
                    }
                    self = .Object(object)
                    
                default:
                    break
            }
        }
    }
}
