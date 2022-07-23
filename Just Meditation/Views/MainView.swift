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
    
    @State var showTimerView: Bool = false
    @State var activeTimer: ActiveTimer = ActiveTimer(durationInMinutes: 7)
    
    var body: some View {
        ZStack {
            if showTimerView {
                TimerView(namespace, activeTimer: $activeTimer, showTimerView: $showTimerView)
            } else {
                HomeView(namespace, showTimerView: $showTimerView, activeTimer: $activeTimer)
            }
        }
        .environmentObject(settings)
        .statusBar(hidden: true)
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
            .previewDevice("Apple Watch Series 7 - 41mm")
    }
}
