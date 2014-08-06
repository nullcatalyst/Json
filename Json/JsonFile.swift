//
//  JsonFile.swift
//  Json
//
//  Created by Scott Bennett on 2014-08-05.
//  Copyright (c) 2014 Scott Bennett. All rights reserved.
//

import Foundation

extension Json {
    static func parseFile(filename: StringType) -> Json? {
        if let contents = StringType.stringWithContentsOfFile(filename, encoding: NSUTF8StringEncoding, error: nil) {
            return parse(contents)
        } else {
            return nil
        }
    }
}
