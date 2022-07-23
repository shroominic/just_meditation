//
//  TimerController.swift
//  Just Meditation WatchKit Extension
//
//  Created by Fungus on 19.07.22.
//

import Foundation
import SwiftUI
import AVFoundation
import HealthKit
import UserNotifications


extension TimerView {
    @MainActor class TimerViewModel: ObservableObject {
        var settings = Settings() // better pass settings through?

        var player: AVAudioPlayer!
        var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        @Published var activeTimer: ActiveTimer
        @Published var dateNow: Date
        @Published var timerRunning: Bool = true
        @Published var timerFinished: Bool = false
        
#if os(watchOS)
        private var session: WKExtendedRuntimeSession?
#endif
        
        init() {
            self.activeTimer = ActiveTimer()
            self.dateNow = Date()
        }
        
        func playSound(sound_name: String) {
            let url = Bundle.main.url(forResource: sound_name, withExtension: "wav")
            
            guard url != nil else { return }
            do {
                player = try AVAudioPlayer(contentsOf: url!)
                player?.play()
            } catch {
                print("error")
            }
        }
        
        func startTimer() {
#if os(watchOS)
            guard session?.state != .running else { return }
            // create or recreate session if needed
            if nil == session || session?.state == .invalid {
                session = WKExtendedRuntimeSession()
            }
            session?.start()
            WKInterfaceDevice.current().play(.click)
            print("wkers started")
#endif
            if settings.soundsEnabled {
                playSound(sound_name: "tibetan_gong_start")
            }
            updateNotification()
        }
        
        func tick() {
            if timerFinished {
                return
            }
            else if Date() >= activeTimer.endDate {
                stopTimer()
            }
            else if timerRunning {
                dateNow = Date()
            } else {
                activeTimer.startDate += 1
                activeTimer.endDate += 1
                updateNotification()
            }
        }
        
        func timerString() -> String {
            return formatter.string(from: activeTimer.timeRemaining())!
        }
        
        func timerCompleted() -> String {
            return activeTimer.alreadyMeditated(dateNow: activeTimer.endDate - 1)
        }
        
        func finishButton() {
            // safe mindful minutes
            safeMindfulMinutes(startDate: activeTimer.startDate, endDate: activeTimer.endDate)
            // screen transition
            withAnimation {
                timerFinished.toggle() // really needed??
            }
        }
        
        func stopButton() {
#if os(watchOS)
            session?.invalidate()
#endif
            withAnimation(.spring(response: 0.25, dampingFraction: 0.7, blendDuration: 1)) {
                timerFinished = true
            }
            clearNotifications()
            // update end date
            activeTimer.endDate = Date()
        }
        
        func stopTimer() {
#if os(watchOS)
            // watch vibrations
            for i in 1...4 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                    WKInterfaceDevice.current().play(.notification)
                }
            }
#endif
            withAnimation(.spring(response: 0.25, dampingFraction: 0.7, blendDuration: 1)) {
                timerFinished = true
            }
            clearNotifications()
            // update end date
            activeTimer.endDate = Date()
            // final haptics and sounds
            if settings.soundsEnabled {
                // short haptics and gong
#if os(watchOS)
                // watch vibrations
                WKInterfaceDevice.current().play(.success)
#endif
                playSound(sound_name: "tibetan_gong_finish")
                
            } else {
                // long haptic feedback (silent mode)
#if os(watchOS)
                for i in 1...4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                        WKInterfaceDevice.current().play(.click)
                    }
                }
#endif
#if os(iOS)
                for i in 1...4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                        AudioServicesPlaySystemSound(1521)
                    }
                }
#endif
            }
#if os(watchOS)
            session?.invalidate()
#endif
        }
        
        func clearNotifications() {
            // clear notifications
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
        
        func updateNotification() {
            if settings.notificationEnabled {
                self.clearNotifications()
            
                let content = UNMutableNotificationContent()
                content.title = "Meditation Finished"
                content.sound = UNNotificationSound.default
                // show this notification five seconds from now
                let interval = Date().distance(to: activeTimer.endDate)
                guard interval > 0 else { return }
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)

                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                // add our notification request
                UNUserNotificationCenter.current().add(request)
            }
        }
        
        func safeMindfulMinutes(startDate: Date, endDate: Date) {
            let healthStore = HKHealthStore()
            if startDate.distance(to: endDate).isLess(than: 60) {
                print("meditation was less than a minute")
                return
            }
            if settings.healthSyncEnabled {
                // alarmTime and endTime are NSDate objects
                if let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession) {
                    // we create our new object we want to push in Health app
                    let mindfullSample = HKCategorySample(type:mindfulType, value: 0, start: startDate, end: endDate)
                    // at the end, we save it
                    healthStore.save(mindfullSample, withCompletion: { (success, error) -> Void in
                        if error != nil { return }
                        if success { print("new data was saved in HealthKit") }
                        else { print("saving of data not successful") }
                    })
                }
            } else { print("saving to health is deactivated") }
        }
    }
}
