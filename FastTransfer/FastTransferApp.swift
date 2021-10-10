//
//  FastTransferApp.swift
//  FastTransfer
//
//  Created by Mikołaj on 10/10/2021.
//

import SwiftUI

@main
struct FastTransferApp: App {

    let address: String

    init() {
        let server = Server()
        address = server.run()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(address: address)
        }
    }
}
