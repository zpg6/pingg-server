//
//  ContentView.swift
//  pingg-server
//
//  Created by Zachary Grimaldi on 10/1/20.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Image("pingg-server-\(colorScheme == .dark ? "white":"black")")
            .resizable()
            .frame(width: 200, height: 116)
            .padding(50)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
