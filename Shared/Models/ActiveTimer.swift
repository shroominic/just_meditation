//
//  ActiveTimer.swift
//  Just Meditation
//
//  Created by Fungus on 09.07.22.
//

import Foundation


let formatter = DateComponentsFormatter()


class ActiveTimer: ObservableObject {
    let id = UUID()
    
    var startDate: Date
    var endDate: Date
    
    func alreadyMeditated(dateNow: Date) -> String {
        let formatter = DateComponentsFormatter()

        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        return formatter.string(from: startDate.distance(to: dateNow))!
    }
    
    func timeMeditated() -> TimeInterval {
        return startDate.distance(to: Date())
    }
    
    func timeRemaining() -> TimeInterval {
        return Date().distance(to: self.endDate)
    }

    init(durationInMinutes: Int = 7) {
        self.startDate = Date()
        self.endDate = Date() + TimeInterval(60*durationInMinutes + 1)
    }
}
