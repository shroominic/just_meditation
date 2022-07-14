//
//  Settings.swift
//  Just Meditation
//
//  Created by Fungus on 09.07.22.
//

import Foundation
import HealthKit
import UserNotifications
import SwiftUI

class Settings: ObservableObject {
    
    @Published var soundsEnabled: Bool = false
    @Published var healthSyncEnabled: Bool = false
    @Published var notificationEnabled: Bool = false
    
    init() {
        // import saved app data
        if let data = UserDefaults.standard.object(forKey: "Settings") as? [String: Bool] {
            self.soundsEnabled = data["soundsEnabled"] ?? false
            self.healthSyncEnabled = data["healthKitActivated"] ?? false
            self.notificationEnabled = data["notificationsEnabled"] ?? false
        }
    }
    
    func saveData() {
        let data: [String: Bool] = [
            "soundsEnabled": self.soundsEnabled,
            "healthKitActivated": self.healthSyncEnabled,
            "notificationsEnabled": self.notificationEnabled
        ]
        UserDefaults.standard.set(data, forKey: "Settings")
    }
    
    
}

