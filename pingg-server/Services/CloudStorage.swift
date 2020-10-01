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
    
    var database: [Int64:Game] = [:]
    var lastUpdated: Date? = nil
    var timer: Timer? = nil
    
    class func setup() {
        CloudStorage.download()
        CloudStorage.main.timer = Timer(timeInterval: 60*60, repeats: true) { (_) in
            CloudStorage.download()
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
                        if let gameData = arr[index].data(using: .utf8) {
                            if let game = try? JSONDecoder().decode(Game.self, from: gameData) {
                                CloudStorage.main.database[game.id] = game
                            } else {
                                print("couldn't decode gameData into a game for index=\(index)")
                            }
                        } else {
                            print("couldn't get gameData from string for index=\(index)")
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
}
