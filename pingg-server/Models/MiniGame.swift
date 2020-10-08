//
//  MiniGame.swift
//  pingg-server
//
//  Created by Joe Paul on 10/8/20.
//

import Foundation

struct MiniGame: Codable {
    var id: Int64 = 0
    var name: String = ""
    var coverURL: String = ""
    var rating: Double = 0.0
    var searchableIndex: [String:Bool] = [:]
}
