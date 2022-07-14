//
//  TimerView.swift
//  Just Meditation
//
//  Created by Fungus on 05.07.22.
//

import SwiftUI
import HealthKit


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
                TimerButtonRow(namespace, activeTimer: $activeTimer, timerRunning: $timerRunning, timerFinished: $timerFinished)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            // every second tick
            .onReceive(timer) { time in
                if Date() >= activeTimer.endDate {
                    timerFinished = true
                }
                else if timerRunning {
                    dateNow = Date()
                } else {
                    activeTimer.endDate = activeTimer.endDate + 1
                }
                
            }
            // when timer starts
            .onAppear() {
                activeTimer.onStart(soundsEnabled: settings.enableSounds)
            }
        } else {
            VStack {
                just_meditation(mode: "meditation")
                Text("time meditated: \(activeTimer.alreadyMeditated(dateNow: Date()))")
                Spacer().frame(maxHeight: .infinity)
                Button(action: finishTimer) {
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
    
    func finishTimer() {
        withAnimation {
            showTimer.toggle()
            timerFinished.toggle()
        }
        // update end date
        activeTimer.endDate = Date()
        // safe mindful minutes
        settings.safeMindfulMinutes(startDate: activeTimer.startDate, endDate: activeTimer.endDate)
    }
    
}


private struct TimerButtonRow: View {
    @EnvironmentObject var settings: Settings
    let namespace: Namespace.ID
        
    @Binding var activeTimer: ActiveTimer
    @Binding var timerRunning: Bool
    @Binding var timerFinished: Bool
    
    init(_ namespace: Namespace.ID, activeTimer: Binding<ActiveTimer>, timerRunning: Binding<Bool>, timerFinished: Binding<Bool>) {
        self.namespace = namespace
        self._activeTimer = activeTimer
        self._timerRunning = timerRunning
        self._timerFinished = timerFinished
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
                Button(action: finishTimer) {
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
                    withAnimation { timerRunning.toggle() }
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
    
    func finishTimer() {
        activeTimer.finish(soundsEnabled: false)
        withAnimation {
            timerFinished = true
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
