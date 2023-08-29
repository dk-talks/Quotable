//
//  QuoteImage.swift
//  Quotable
//
//  Created by Dinesh Sharma on 24/08/23.
//

import Foundation

struct QuoteImage: Decodable {
    let page: Int
    let per_page: Int
    let photos: [QuotePhoto]
}

struct QuotePhoto: Decodable {
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    let photographer_url: String
    let src: Source
    
}

struct Source: Decodable {
    let original: String
    let medium: String
}

