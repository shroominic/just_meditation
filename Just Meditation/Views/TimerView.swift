//
//  TimerView.swift
//  Just Meditation
//
//  Created by Fungus on 05.07.22.
//

import SwiftUI
import HealthKit
import UserNotifications
import AudioToolbox


struct TimerView: View {
    @EnvironmentObject var settings: Settings
    let namespace: Namespace.ID
    
    @Binding var activeTimer: ActiveTimer
    @Binding var showTimer: Bool
    
    @State var dateNow: Date
    @State var timerRunning: Bool = true
    @State var timerFinished: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(_ namespace: Namespace.ID, activeTimer: Binding<ActiveTimer>, showTimerView: Binding<Bool>) {
        self.namespace = namespace
        self._activeTimer = activeTimer
        self._showTimer = showTimerView
        self._dateNow = State(initialValue: Date())
    }
    
    var body: some View {
        if !timerFinished {
            VStack {
                // Header
                just_meditation(mode: "meditation")
                // Timer View
                HStack{
                    Text(activeTimer.toString(dateNow: dateNow))
                        .font(.system(size: 80, weight: .ultraLight, design: .rounded))
                }
                .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
                .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
                // Buttons
                TimerButtonRow(namespace, activeTimer: $activeTimer, timerRunning: $timerRunning, stop_button: stopButton)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            // every second tick
            .onReceive(timer) { time in
                if Date() >= activeTimer.endDate {
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
            // when timer starts
            .onAppear() {
                activeTimer.onStart(soundsEnabled: settings.soundsEnabled)
                updateNotification()
            }
        } else {
            VStack {
                just_meditation(mode: "meditation")
                Text("You completed \(activeTimer.alreadyMeditated(dateNow: activeTimer.endDate - 1))")
                Spacer().frame(maxHeight: .infinity)
                Button(action: finishButton) {
                    Text("FINISH")
                        .frame(height: 28)
                        .padding()
                        .font(.system(size: 20, weight: .light, design: .monospaced))
                        .foregroundColor(.white)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white, lineWidth: 1)
                        .matchedGeometryEffect(id: "buttonCase", in: namespace)
                )
            }
        }
    }
    
    func finishButton() {
        // safe mindful minutes
        safeMindfulMinutes(startDate: activeTimer.startDate, endDate: activeTimer.endDate)
        // screen transition
        withAnimation {
            showTimer.toggle()
            timerFinished.toggle() // really needed??
        }
    }
    
    func stopButton() {
        timerFinished = true
        clearNotifications()
        // update end date
        activeTimer.endDate = Date()
    }
    
    func stopTimer() {
        stopButton()
        // final haptics and sounds
        if settings.soundsEnabled {
            // short haptics and gong
            AudioServicesPlaySystemSound(1521)
            playSound(sound_name: "tibetan_gong_finish")
        } else {
            // long haptic feedback (silent mode)
            for i in 1...4 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                    AudioServicesPlaySystemSound(1521)
                }
            }
        }
        
        
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
            content.sound = UNNotificationSound(named:UNNotificationSoundName(rawValue: "tibetan_gong_finish.wav"))

            // show this notification five seconds from now
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Date().distance(to: activeTimer.endDate), repeats: false)

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


private struct TimerButtonRow: View {
    @EnvironmentObject var settings: Settings
    let namespace: Namespace.ID
        
    @Binding var activeTimer: ActiveTimer
    @Binding var timerRunning: Bool
    
    var stopButton: () -> Void
    
    init(_ namespace: Namespace.ID, activeTimer: Binding<ActiveTimer>, timerRunning: Binding<Bool>, stop_button: @escaping () -> Void) {
        self.namespace = namespace
        self._activeTimer = activeTimer
        self._timerRunning = timerRunning
        self.stopButton = stop_button
    }
    
    var body: some View {
        if !timerRunning {
            HStack {
                Button(action: {
                    withAnimation {
                        timerRunning.toggle()
                    }
                }){
                    Image(systemName: "play")
                        .frame(width: 20, height: 20)
                        .padding(20)
                        .foregroundColor(.white)
                }
                .offset(x: 22)
                Button(action: stopButton) {
                    Image(systemName: "stop")
                        .frame(width: 20, height: 20)
                        .foregroundColor(.red)
                        .padding(8)
                        .offset(x: 8)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white, lineWidth: 1)
                    .matchedGeometryEffect(id: "buttonCase", in: namespace)
                    .offset(x: 22)
            )
        } else {
            HStack {
                Button(action: {
                    withAnimation {
                        timerRunning.toggle()
                    }
                }){
                    Image(systemName: "pause")
                        .frame(width: 20, height: 20)
                        .padding(20)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white, lineWidth: 1)
                        .matchedGeometryEffect(id: "buttonCase", in: namespace)
                )
                .foregroundColor(.white)
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        TimerView(namespace, activeTimer: Binding.constant(ActiveTimer(durationInMinutes: 7)), showTimerView: Binding.constant(true))
            .preferredColorScheme(.dark)
            .environmentObject(Settings())
    }
}
