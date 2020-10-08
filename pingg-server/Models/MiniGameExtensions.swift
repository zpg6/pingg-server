//
//  MiniGameExtensions.swift
//  pingg-server
//
//  Created by Joe Paul on 10/8/20.
//

import Foundation

extension MiniGame {

    static func from(_ object: [String:Any]) -> MiniGame {
        
        var miniGame = MiniGame()
        
        if let id = object["id"] as? Int64 {
            miniGame.id = id
        }
        
        if let name = object["name"] as? String {
            miniGame.name = name
        }
        
        if let coverURL = object["coverURL"] as? String {
            miniGame.coverURL = coverURL
        }
        
        if let rating = object["rating"] as? Double {
            miniGame.rating = rating
        }
        
        if let searchableIndex = object["searchableIndex"] as? [String:Bool] {
            miniGame.searchableIndex = searchableIndex
        }
        
        return miniGame
    }
    
    static func fromGame(_ object: Game) -> MiniGame {
        
        var miniGame = MiniGame()
        
        miniGame.id = object.id
        
        miniGame.name = object.name
        
        miniGame.coverURL = object.coverURL
        
        miniGame.rating = object.rating
        
        miniGame.searchableIndex = object.searchableIndex
        
        return miniGame
    }

    var json: [String:Any] {

        var result = [String:Any]()
        
        result["id"] = self.id
        result["name"] = self.name
        result["coverURL"] = self.coverURL
        result["rating"] = self.rating
        result["searchableIndex"] = self.searchableIndex
        
        return result
    }
}

