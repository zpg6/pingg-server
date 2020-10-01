//
//  ContentView.swift
//  pingg-server
//
//  Created by Zachary Grimaldi on 10/1/20.
//

import SwiftUI

struct ContentView: View {
    
    let admin: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Image("pingg-server-\(colorScheme == .dark ? "white":"black")")
                .resizable()
                .frame(width: 200, height: 116)
                .padding(50)
                .onTapGesture {
                    print("\(CloudStorage.main.database.count) games in memory. Last Updated: \(CloudStorage.main.lastUpdated?.debugDescription ?? "never received games.")")
                }
            
            Text("admin auth uid: " + admin)
                .bold()
                .padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(admin: "preview, not auth'd")
    }
}
