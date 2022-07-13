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
            just_meditation(mode: "just")
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
            HomeButtonRow(namespace: namespace, showTimerView: $showTimerView, activeTimer: $activeTimer, duration: $duration)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
    
}

private struct HomeButtonRow: View {
    let namespace: Namespace.ID
    
    @State var showSettings: Bool = false
    @State var showInfo: Bool = false
    @Binding var showTimerView: Bool
    @Binding var activeTimer: ActiveTimer
    @Binding var duration: Int
    
    var body: some View {
        if showSettings {
            HStack(alignment: .top) {
                if showInfo {
                    InfoView()
                } else {
                    SettingsView()
                        .padding()
                }
                VStack {
                    Button(action: {
                        withAnimation {
                            showSettings.toggle()
                            showInfo = false
                        }
                    }){
                        Image(systemName: "gear.badge.xmark")
                            .padding(10)
                            .foregroundColor(.white)
                            .matchedGeometryEffect(id: "settingsgear", in: namespace)
                    }
                    Button(action: {
                        withAnimation {
                            showInfo.toggle()
                        }
                    }) {
                        Image(systemName: showInfo ? "info.circle.fill": "info.circle")
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .foregroundColor(.white)
                    }
                }
                
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white, lineWidth: 1)
                    .matchedGeometryEffect(id: "settings", in: namespace)
            )
            .padding()
            
        } else {
            HStack {
                Spacer()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    activeTimer = ActiveTimer(durationInMinutes: duration)
                    withAnimation {
                        showTimerView.toggle()
                    }
                }){
                    Image(systemName: "play")
                        .frame(width: 20, height: 20)
                        .padding(20)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.white, lineWidth: 1)
                                .matchedGeometryEffect(id: "buttonCase", in: namespace)
                        )
                        .offset(x: 4)
                }
                Button(action: {
                    withAnimation {
                        showSettings.toggle()
                    }
                }){
                    Image(systemName: "gear")
                        .padding(10)
                        .foregroundColor(.white)
                        .matchedGeometryEffect(id: "settingsgear", in: namespace)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.white, lineWidth: 1)
                                .matchedGeometryEffect(id: "settings", in: namespace)
                        )
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
            }
        }
    }
}

private struct InfoView: View {
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        VStack {
            Text("""
            Thanks for using just_meditation!
            I hope I could help you to clear the mind :D
            
            If you want to support me just leave a rating in the AppStore.
            
            socials: [linktr.ee/shroominic](https://linktr.ee/shroominic)
            """)
                .font(.system(size: 13, weight: .light, design: .monospaced))
            Text("v\(appVersion ?? "no_version_found")")
                .font(.system(size: 8, design: .monospaced))
                .padding(.top, 5)
                .foregroundColor(.init(white: 0.3))
        }
        .padding()
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
