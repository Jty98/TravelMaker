//
//  Result.swift
//  TravelMaker
//
//  Created by JinYeong Lee on 2023/09/27.
//

import Foundation

struct ResultJSON: Codable{
    var result1: String
    var result2: String
    var result3: String
    var result4: String
    var result5: String
}

struct Result: Codable{
    let results: [ResultJSON]
}
