//
//  WebServer.swift
//  pingg-server
//
//  Created by Zachary Grimaldi on 10/1/20.
//

import Foundation
import GCDWebServer

class WebServer {
    
    static let main = WebServer()
    var server = GCDWebServer()
    let returnSize = 7
    
    class func startup() {
        WebServer.main.server.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self, processBlock: {request in
            let response = GCDWebServerDataResponse(html:"<html><body><p>Hello World</p></body></html>")
            if let response = response?.addHeaders() {
                return response
            }
            return response
                
            })
        
        WebServer.main.server.addHandler(forMethod: "GET", path: "/database", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: CloudStorage.main.database)
                    if let response = response?.addHeaders() {
                        return response
                    } else {
                        print("Error adding headers")
                    }
                    return response
        
                }
        
        WebServer.main.server.addHandler(forMethod: "GET", path: "/mini-game-database", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: CloudStorage.main.miniGameDatabase)
                    if let response = response?.addHeaders() {
                        return response
                    } else {
                        print("Error adding headers")
                    }
                    return response
        
                }
        
        WebServer.main.server.addHandler(forMethod: "GET", path: "/count/genres", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: CloudStorage.main.numGamesPerGenre)
                    if let response = response?.addHeaders() {
                        return response
                    } else {
                        print("Error adding headers")
                    }
                    return response
        
                }
        
        WebServer.main.server.addHandler(forMethod: "GET", path: "/count/platforms", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            let response = GCDWebServerDataResponse(jsonObject: CloudStorage.main.numGamesPerPlatform)
                    if let response = response?.addHeaders() {
                        return response
                    } else {
                        print("Error adding headers")
                    }
                    return response
        
                }
        
        WebServer.main.server.addHandler(forMethod: "OPTIONS", path: "/top-rated", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
                let response = GCDWebServerDataResponse(jsonObject: [:])
                if let response = response?.addHeaders() {
                    return response
                } else {
                    print("Error adding headers")
                }
                return response
            }
        
        WebServer.main.server.addHandler(forMethod: "POST", path: "/top-rated", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            
            if let requestData = request as? GCDWebServerDataRequest {
                let data = requestData.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                        if let offset = dict["offset"] as? Int {
                            let database = CloudStorage.main.database
                            let array = database.map({$0.value}).sorted(by: {Game.from($0)!.rating > Game.from($1)!.rating})
                            var returnArray: [[String:Any]] = []
                            var j=0
                            let maxNum = (offset + WebServer.main.returnSize) > CloudStorage.main.database.count ? CloudStorage.main.database.count : (offset + WebServer.main.returnSize)
                            for i in offset...maxNum {
                                if array.count > i {
                                    let fullGameJSON = array[i]
                                    if let id = fullGameJSON["id"] as? Int64 {
                                        if let miniGame = CloudStorage.main.miniGameDatabase[String(id)] {
                                            returnArray.append(miniGame)
                                            j+=1
                                        }
                                    }
                                }
                            }
                            

                            let response = GCDWebServerDataResponse(jsonObject: returnArray)
                                    if let response = response?.addHeaders() {
                                        //print(response)
                                        return response
                                    } else {
                                        print("Error adding headers")
                                    }
                                    return response
                        } else {
                            return GCDWebServerErrorResponse(text: "Missing Offset Field")?.addHeaders()
                        }
                    } else {
                        return GCDWebServerErrorResponse(text: "Could not cast data.")?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: "Could not serialize data.")?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: "Could not cast data.")?.addHeaders()
            }
        }
        
        WebServer.main.server.addHandler(forMethod: "OPTIONS", path: "/most-rated", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
                let response = GCDWebServerDataResponse(jsonObject: [:])
                if let response = response?.addHeaders() {
                    return response
                } else {
                    print("Error adding headers")
                }
                return response
            }
        
        WebServer.main.server.addHandler(forMethod: "POST", path: "/most-rated", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
            
            if let requestData = request as? GCDWebServerDataRequest {
                let data = requestData.data
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    if let dict = json as? [String:Any] {
                        if let offset = dict["offset"] as? Int {
                            let database = CloudStorage.main.database
                            let array = database.map({$0.value}).sorted(by: {Game.from($0)!.ratingCount > Game.from($1)!.ratingCount})
                            var returnArray: [[String:Any]] = []
                            var j=0
                            let maxNum = (offset + WebServer.main.returnSize) > CloudStorage.main.database.count ? CloudStorage.main.database.count : (offset + WebServer.main.returnSize)
                            for i in offset...maxNum {
                                if array.count > i {
                                    let fullGameJSON = array[i]
                                    if let id = fullGameJSON["id"] as? Int64 {
                                        if let miniGame = CloudStorage.main.miniGameDatabase[String(id)] {
                                            returnArray.append(miniGame)
                                            j+=1
                                        }
                                    }
                                }
                            }
                            

                            let response = GCDWebServerDataResponse(jsonObject: returnArray)
                                    if let response = response?.addHeaders() {
                                        //print(response)
                                        return response
                                    } else {
                                        print("Error adding headers")
                                    }
                                    return response
                        } else {
                            return GCDWebServerErrorResponse(text: "Missing Offset Field")?.addHeaders()
                        }
                    } else {
                        return GCDWebServerErrorResponse(text: "Could not cast data.")?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: "Could not serialize data.")?.addHeaders()
                }
            } else {
                return GCDWebServerErrorResponse(text: "Could not cast data.")?.addHeaders()
            }
        
        }
        
        WebServer.main.server.addHandler(forMethod: "OPTIONS", path: "/genre", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
                let response = GCDWebServerDataResponse(jsonObject: [:])
                if let response = response?.addHeaders() {
                    return response
                } else {
                    print("Error adding headers")
                }
                return response
            }

            WebServer.main.server.addHandler(forMethod: "POST", path: "/genre", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in

                print(request)

                if let requestData = request as? GCDWebServerDataRequest {
                    let data = requestData.data
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                        if let dict = json as? [String:Any] {
                            if let genre = dict["genre"] as? String {
                                if let offset = dict["offset"] as? Int {
                                    var array : [[String:Any]] = []
                                    let database = CloudStorage.main.database
                                    for (_, value) in database {
                                        if let genres = value["genres"] as? Array<String> {
                                            if genres.contains(genre) {
                                                array.append(value)
                                            }
                                        }
                                    }
                                    var returnArray = [[String:Any]]()
                                    let maxNum = (offset + WebServer.main.returnSize) > CloudStorage.main.database.count ? CloudStorage.main.database.count : (offset + WebServer.main.returnSize)
                                    for i in offset...maxNum {
                                        print("array size: " + String(array.count))
                                        if array.count > i {
                                            let fullGameJSON = array[i]
                                            if let id = fullGameJSON["id"] as? Int64 {
                                                if let miniGame = CloudStorage.main.miniGameDatabase[String(id)] {
                                                    returnArray.append(miniGame)
                                                }
                                            }
                                        }
                                    }
                                    return GCDWebServerDataResponse(jsonObject: returnArray)?.addHeaders()
                                } else {
                                    return GCDWebServerErrorResponse(text: "Missing Offset Field")?.addHeaders()
                                }
                            } else {
                                return GCDWebServerErrorResponse(text: "Missing Genre Field")?.addHeaders()
                            }
                        } else {
                            return GCDWebServerErrorResponse(text: "Could not cast data.")?.addHeaders()
                        }
                    } else {
                        return GCDWebServerErrorResponse(text: "Could not serialize data.")?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: "Could not cast data.")?.addHeaders()
                }
            }
        
        
        
        WebServer.main.server.addHandler(forMethod: "OPTIONS", path: "/game/add", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
                let response = GCDWebServerDataResponse(jsonObject: [:])
                if let response = response?.addHeaders() {
                    return response
                } else {
                    print("Error adding headers")
                }
                return response
            }
        
            WebServer.main.server.addHandler(forMethod: "POST", path: "/game/add", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
        
                print(request)
        
                if let requestData = request as? GCDWebServerDataRequest {
                    let data = requestData.data
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                        if let dict = json as? [String:Any] {
                            if let game = Game.from(dict) {
                                CloudStorage.main.database[String(game.id)] = game.json
                                return GCDWebServerDataResponse(jsonObject: game.json)?.addHeaders()
                            } else {
                                return GCDWebServerErrorResponse(text: "Missing ID field")?.addHeaders()
                            }
                        } else {
                            return GCDWebServerErrorResponse(text: "Could not cast data.")?.addHeaders()
                        }
                    } else {
                        return GCDWebServerErrorResponse(text: "Could not serialize data.")?.addHeaders()
                    }
                } else {
                    return GCDWebServerErrorResponse(text: "Could not cast data.")?.addHeaders()
                }
            }
        
        
        
        
        
        
        
        
        
        
        
//        WebServer.main.server.addHandler(forMethod: "OPTIONS", path: "/game/upvote", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
//            let response = GCDWebServerDataResponse(jsonObject: [:])
//            if let response = response?.addHeaders() {
//                return response
//            } else {
//                print("Error adding headers")
//            }
//            return response
//        }
//        
//        WebServer.main.server.addHandler(forMethod: "POST", path: "/game/upvote", request: GCDWebServerDataRequest.self) { (request) -> GCDWebServerDataResponse? in
//        
//            print(request)
//        
//            if let requestData = request as? GCDWebServerDataRequest {
//                let data = requestData.data
//                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
//                    if let dict = json as? [String:Any] {
//                        if let email = dict["email"] as? String {
//                            if let pass = dict["password"] as? String, pass.count > 0 {
//                                let userAuthenticationResult = FirebaseWrapper.authenticateUser(email: email, password: pass, ipAddress: ipAddress)
//        
//                                        // if the authentication process returned an error
//                                if let error = userAuthenticationResult.error {
//                                    return GCDWebServerErrorResponse(text: error.output)?.addHeaders()
//                                } else {
//        
//                                            // if the user is successfully authenticated
//                                    if let authenticated = userAuthenticationResult.successful,
//                                                authenticated, let user = userAuthenticationResult.user {
//                                        return GCDWebServerDataResponse(jsonObject: user)?.addHeaders()
//                                    } else {
//                                        return GCDWebServerErrorResponse(text: StockManagerError.AuthenticationErrors.invalidCredentials.output)?.addHeaders()
//                                    }
//                                }
//                            } else {
//                                return GCDWebServerErrorResponse(text: StockManagerError.AuthenticationErrors.missingCredentials.output)?.addHeaders()
//                            }
//                        } else {
//                            return GCDWebServerErrorResponse(text: StockManagerError.AuthenticationErrors.missingCredentials.output)?.addHeaders()
//                        }
//                    } else {
//                        return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.castingError.output)?.addHeaders()
//                    }
//                } else {
//                    return GCDWebServerErrorResponse(text: StockManagerError.JSONErrors.serializationError.output)?.addHeaders()
//                }
//            } else {
//                return GCDWebServerErrorResponse(text: StockManagerError.APIErrors.castingError.output)?.addHeaders()
//            }
//        } .

        WebServer.main.server.start(withPort: 9000, bonjourName: "GCD Web Server")

    }
}

extension GCDWebServerDataResponse {
    func addHeaders() -> GCDWebServerDataResponse {
        let response = self
        response.setValue("*", forAdditionalHeader: "Access-Control-Allow-Origin")
        response.setValue("GET, POST, PUT, HEAD, OPTIONS", forAdditionalHeader: "Access-Control-Allow-Methods")
        response.setValue("Content-Type", forAdditionalHeader: "Access-Control-Allow-Headers")
        response.setValue("true", forAdditionalHeader: "Access-Control-Allow-Credentials")
        return response
    }
}
