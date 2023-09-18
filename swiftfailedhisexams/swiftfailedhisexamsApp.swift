//
//  swiftfailedhisexamsApp.swift
//  swiftfailedhisexams
//
//  Created by Cyber Slayer on 18/9/23.
//

import SwiftUI
import SwiftData

@main
struct swiftfailedhisexamsApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
