//
//  CountryData.swift
//  Quotable
//
//  Created by Dinesh Sharma on 12/08/23.
//

import Foundation

struct Country: Decodable {

    let name: Name
    let idd: Code
    let flags: Flag
    let altSpellings: [String]
}

struct Name: Decodable, Comparable {
    static func < (lhs: Name, rhs: Name) -> Bool {
        return lhs.common < rhs.common
    }
    
    let common: String
}

struct Code: Decodable {
    let root: String
    let suffixes: [String]
}

struct Flag: Decodable {
    let png: String
}
