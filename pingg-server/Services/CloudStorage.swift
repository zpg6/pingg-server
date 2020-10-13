//
//  CloudStorage.swift
//  pingg-server
//
//  Created by Zachary Grimaldi on 10/1/20.
//

import Foundation
import Firebase

class CloudStorage {
    
    static let main = CloudStorage()
    var database: [String:[String:Any]] = [:]
    var miniGameDatabase: [String:[String:Any]] = [:]
    var lastUpdated: Date? = nil
    var timer: Timer? = nil
    var numGamesPerGenre: [String:Int64] = [:]
    var numGamesPerPlatform: [String:Int64] = [:]
    
    class func setup() {
        CloudStorage.download()
        CloudStorage.main.timer = Timer(timeInterval: 60*60, repeats: true) { (_) in
            CloudStorage.upload()
        }
    }
    
    class func download() {
        print("downloading database.json from Cloud Storage")
        Storage.storage().reference(withPath: "database.json").getData(maxSize: 10000000) { (data, err) in
            if let err = err {
                print("CloudStorage.download: err = \(err.localizedDescription)")
            }
            if let data = data {
                if let arr = try? JSONDecoder().decode([String].self, from: data) {
                    for index in 0..<arr.count {
                        if let gameData = Data(base64Encoded: arr[index]) {
                            if let game = try? JSONDecoder().decode(Game.self, from: gameData) {
                                CloudStorage.main.database[String(game.id)] = game.json
                                CloudStorage.main.miniGameDatabase[String(game.id)] = MiniGame.fromGame(game).json
                                for genre in game.genres {
                                    if CloudStorage.main.numGamesPerGenre.keys.contains(genre) {
                                        CloudStorage.main.numGamesPerGenre[genre] = CloudStorage.main.numGamesPerGenre[genre]! + 1
                                    } else {
                                        CloudStorage.main.numGamesPerGenre[genre] = 1
                                    }
                                }
                                for platform in game.platforms {
                                    if CloudStorage.main.numGamesPerPlatform.keys.contains(platform) {
                                        CloudStorage.main.numGamesPerPlatform[platform] = CloudStorage.main.numGamesPerPlatform[platform]! + 1
                                    } else {
                                        CloudStorage.main.numGamesPerPlatform[platform] = 1
                                    }
                                }
                            } else {
                                print("couldn't decode gameData into a game for index=\(index)")
                            }
                        } else {
                            print("couldn't get gameData from string for index=\(index)")
                        }
                    }
                    for (key, value) in CloudStorage.main.database {
                        if let similarGames = value["similarGames"] as? Array<Int64> {
                            for similarGame in similarGames {
                                if !CloudStorage.main.database.keys.contains(String(similarGame)) {
                                    let tempArray = CloudStorage.main.database[key]?["similarGames"] as? Array<Int64>
                                    CloudStorage.main.database[key]?["similarGames"] = tempArray?.filter({
                                        $0 != similarGame
                                    })
                                }
                            }
                        }
                    }
                    CloudStorage.main.lastUpdated = Date()
                } else {
                    print("couldn't decode JSON into an array of strings")
                }
            } else {
                print("couldn't retrieve database.json")
            }
        }
    }
    
    class func upload() {
        var gameArray = [String]()
        for (_ ,game) in CloudStorage.main.database {
            if let game = Game.from(game) {
                gameArray.append((try? JSONEncoder().encode(game).base64EncodedString()) ?? "")
            }
        }
        if let data = gameArray.description.data(using: .utf8){
            Storage.storage().reference(withPath: "database.json").putData(data)
        }
    }
}
