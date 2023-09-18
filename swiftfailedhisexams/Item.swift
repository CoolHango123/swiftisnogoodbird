//
//  Item.swift
//  swiftfailedhisexams
//
//  Created by Cyber Slayer on 18/9/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
