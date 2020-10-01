//
//  Game.swift
//  pingg-server
//
//  Created by Zachary Grimaldi on 10/1/20.
//

import Foundation

struct Game: Codable {
    var id: Int64 = 0
    var name: String = ""
    var ageRatings: [String] = []
    var description: String = ""
    var coverURL: String = ""
    var firstReleaseDate: Int64 = 0
    var franchise: String = ""
    var genres: [String] = []
    var platforms: [String] = []
    var similarGames: [Int64] = []
    var rating: Double = 0.0
    var ratingCount: Int64 = 0
    var screenshots: [String] = []
    var searchableIndex: [String:Bool] = [:]
    var videos: [String] = []
}
