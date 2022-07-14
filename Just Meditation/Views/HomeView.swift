//
//  HomeView.swift
//  Just Meditation
//
//  Created by Fungus on 04.07.22.
//

import SwiftUI
import HealthKit

struct HomeView: View {
    @EnvironmentObject var settings: Settings
    let namespace: Namespace.ID
    
    @State var duration: Int = 7
    
    @Binding var showTimerView: Bool
    @Binding var activeTimer: ActiveTimer
    
    var body: some View {
        VStack {
            // TITLE
            just_meditation(mode: "just")
            // PICK A DURATION
            HStack {
                Text("DURATION")
                    .font(.system(size: 24, weight: .ultraLight, design: .monospaced))
                
                Picker("Duration", selection: $duration, content: {
                    ForEach(1...60, id: \.self) {i in
                        Text("\(i)").tag(i)
                            .font(.system(size: 20, weight: .light))
                    }
                    Text("90").tag(90)
                        .font(.system(size: 20, weight: .light))
                    Text("120").tag(120)
                        .font(.system(size: 20, weight: .light))
                    Text("180").tag(180)
                        .font(.system(size: 20, weight: .light))
                    Text("240").tag(240)
                        .font(.system(size: 20, weight: .light))
                    Text("300").tag(300)
                        .font(.system(size: 20, weight: .light))
                    Text("360").tag(360)
                        .font(.system(size: 20, weight: .light))
                    Text("420").tag(420)
                        .font(.system(size: 20, weight: .light))
                })
                .pickerStyle(.wheel)
                .foregroundColor(.red)
                .frame(width: 35, height: 59)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.gray, lineWidth: 1)
                )
                .padding(.horizontal)
                Text("MIN")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .background(Color.init(white: 0.03))
            .cornerRadius(12)
            // BUTTONS
            HomeButtonRow(namespace: namespace, showTimerView: $showTimerView, activeTimer: $activeTimer, duration: $duration)
                
        }
    }
    
}

private struct HomeButtonRow: View {
    let namespace: Namespace.ID
    
    @State var showInfo: Bool = false
    @Binding var showTimerView: Bool
    @Binding var activeTimer: ActiveTimer
    @Binding var duration: Int
    
    var body: some View {
        ZStack {
            PlayButton(namespace: namespace, playButtonAction: playButtonAction)
                .frame(maxHeight: .infinity, alignment: .bottom)
            SettingsView(namespace: namespace)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        
    }
    
    func playButtonAction() {
        activeTimer = ActiveTimer(durationInMinutes: duration)
        withAnimation {
            showTimerView.toggle()
        }
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
    }
    
}

struct PlayButton: View {
    var namespace: Namespace.ID
    var playButtonAction: () -> Void
    
    var body: some View {
        Button(action: playButtonAction){
            Image(systemName: "play")
                .frame(width: 20, height: 20)
                .padding(20)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white, lineWidth: 1)
                        .matchedGeometryEffect(id: "buttonCase", in: namespace)
                )
    }
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}

struct HomeView_Previews: PreviewProvider {
    @Namespace static var namespace
    @StateObject static var settings = Settings()
    
    static var previews: some View {
        HomeView(namespace: namespace, showTimerView: Binding.constant(false), activeTimer: Binding.constant(ActiveTimer(durationInMinutes: 7)))
            .preferredColorScheme(.dark)
            .environmentObject(settings)
    }
}
