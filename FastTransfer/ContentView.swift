//
//  ContentView.swift
//  FastTransfer
//
//  Created by Mikołaj on 10/10/2021.
//

import SwiftUI

struct ContentView : View {

    let address: String

    var body: some View {
        Text("FastTransfer server started!").padding(.top)
        Link(address, destination: URL(string: address)!).padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(address: "http://localhost:8090")
    }
}
