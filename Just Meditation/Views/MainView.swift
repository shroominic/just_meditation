//
//  MainView.swift
//  Just Meditation
//
//  Created by Fungus on 09.07.22.
//

import SwiftUI

struct MainView: View {
    @Namespace var namespace
    
    @StateObject var settings = Settings()
    
    @State var showSettings: Bool = false
    @State var showTimerView: Bool = false
    
    @State var activeTimer: ActiveTimer = ActiveTimer(durationInMinutes: 7)
    
    var body: some View {
        ZStack {
            if showTimerView {
                TimerView(namespace, activeTimer: $activeTimer, showTimerView: $showTimerView)
            } else {
                HomeView(namespace: namespace, showTimerView: $showTimerView, activeTimer: $activeTimer)
            }
        }
        .environmentObject(settings)
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}
