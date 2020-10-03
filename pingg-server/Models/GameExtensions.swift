//
//  GameExtensions.swift
//  pingg-server
//
//  Created by Joe Paul on 10/3/20.
//

import Foundation

extension Game {

    static func from(_ object: [String:Any]) -> Game {
        
        var game = Game()
        
        if let id = object["id"] as? Int64 {
            game.id = id
        }
        
        if let name = object["name"] as? String {
            game.name = name
        }
        
        if let ageRatings = object["ageRatings"] as? [String] {
            game.ageRatings = ageRatings
        }
        
        if let description = object["description"] as? String {
            game.description = description
        }
        
        if let coverURL = object["coverURL"] as? String {
            game.coverURL = coverURL
        }
        
        if let firstReleaseDate = object["firstReleaseDate"] as? Int64 {
            game.firstReleaseDate = firstReleaseDate
        }
        
        if let franchise = object["franchise"] as? String {
            game.franchise = franchise
        }
        
        if let genres = object["genres"] as? [String] {
            game.genres = genres
        }
        
        if let platforms = object["platforms"] as? [String] {
            game.platforms = platforms
        }
        
        if let similarGames = object["similarGames"] as? [Int64] {
            game.similarGames = similarGames
        }
        
        if let rating = object["rating"] as? Double {
            game.rating = rating
        }
        
        if let ratingCount = object["ratingCount"] as? Int64 {
            game.ratingCount = ratingCount
        }
        
        if let screenshots = object["screenshots"] as? [String] {
            game.screenshots = screenshots
        }
        
        if let searchableIndex = object["searchableIndex"] as? [String:Bool] {
            game.searchableIndex = searchableIndex
        }
        
        if let videos = object["videos"] as? [String] {
            game.videos = videos
        }
        
        return game
    }

    var json: [String:Any] {

        var result = [String:Any]()
        
        result["id"] = self.id
        result["name"] = self.name
        result["ageRatings"] = self.ageRatings
        result["description"] = self.description
        result["coverURL"] = self.coverURL
        result["firstReleaseDate"] = self.firstReleaseDate
        result["franchise"] = self.franchise
        result["genres"] = self.genres
        result["platforms"] = self.platforms
        result["similarGames"] = self.similarGames
        result["rating"] = self.rating
        result["ratingCount"] = self.ratingCount
        result["screenshots"] = self.screenshots
        result["searchableIndex"] = self.searchableIndex
        result["videos"] = self.videos
        
        return result
    }
}
