//
//  Settings.swift
//  Just Meditation
//
//  Created by Fungus on 09.07.22.
//

import Foundation
import HealthKit

class Settings: ObservableObject {
    let healthStore = HKHealthStore()
    
    @Published var enableSounds: Bool = false
    @Published var healthKitActivated: Bool = false
    @Published var enableNotification: Bool = false
    
    func activateHealthKit() {
        let typestoRead = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
        ])
        
        let typestoShare = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
        ])
        
        self.healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
            if success == false {
                self.healthKitActivated = false
                print("solve this error\(String(describing: error))")
                NSLog(" Display not allowed")
            }
            if success == true {
                self.healthKitActivated = true
                print("dont worry everything is good \(success)")
                NSLog(" Integrated SuccessFully")
            }
        }
    }
    
    func safeMindfulMinutes(startDate: Date, endDate: Date) {
        if healthKitActivated {
            // alarmTime and endTime are NSDate objects
            if let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession) {
                // we create our new object we want to push in Health app
                let mindfullSample = HKCategorySample(type:mindfulType, value: 0, start: startDate, end: endDate)
                
                // at the end, we save it
                healthStore.save(mindfullSample, withCompletion: { (success, error) -> Void in
                    
                    if error != nil {
                        print("there is some error")
                        return
                    }
                    
                    if success {
                        print("My new data was saved in HealthKit")
                    } else {
                        print("Safing of data not successful")
                    }
                })
            }
        } else {
            print("apple health deactivated")
        }
    }
}

