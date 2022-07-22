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
        ZStack {
            // TITLE
#if os(iOS)
            just_meditation(mode: "just")
                .frame(maxHeight: .infinity, alignment: .top)
#endif
            // PICK A DURATION
            PickerView(duration: $duration)
#if os(watchOS)
                .frame(maxHeight: .infinity, alignment: .top)
#endif
            // BUTTONS
            PlayButtonView(namespace: namespace, playButtonAction: playButtonAction)
                .frame(maxHeight: .infinity, alignment: .bottom)
#if os(iOS)
            SettingsView(namespace: namespace)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
#endif
                
        }
    }
    
    func playButtonAction() {
        activeTimer = ActiveTimer(durationInMinutes: duration)
        withAnimation {
            showTimerView.toggle()
        }
#if os(iOS)
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
#endif
#if os(watchOS)
        WKInterfaceDevice.current().play(.start)
#endif
    }
    
}


private struct PlayButtonView: View {
    var namespace: Namespace.ID
    var playButtonAction: () -> Void
    
    var body: some View {
        Image(systemName: "play")
            .frame(width: 20, height: 20)
            .padding(20)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white, lineWidth: 1)
                    .matchedGeometryEffect(id: "buttonCase", in: namespace)
            )
            .onTapGesture(perform: playButtonAction)
            
            .frame(maxHeight: .infinity, alignment: .bottom)
#if os(watchOS)
            .offset(y: 6)
#endif
    }
}


struct HomeView_Previews: PreviewProvider {
    @Namespace static var namespace
    @StateObject static var settings = Settings()
    
    static var previews: some View {
        HomeView(namespace: namespace, showTimerView: Binding.constant(false), activeTimer: Binding.constant(ActiveTimer(durationInMinutes: 7)))
            .environmentObject(settings)
            .preferredColorScheme(.dark)
            
    }
}
