//
//  SettingsView.swift
//  Just Meditation
//
//  Created by Fungus on 09.07.22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        VStack {
            // APPLE HEALTH BUTTON
            SettingsItem(buttonAction: {
                if settings.healthKitActivated {
                    withAnimation {
                        settings.healthKitActivated.toggle()
                    }
                } else {
                    withAnimation {
                        settings.activateHealthKit()
                    }
                }
            }, switchVar: $settings.healthKitActivated)
            // SOUNDS BUTTON
            Button(action: {
                withAnimation {
                    settings.enableSounds.toggle()
                }
            }) {
                HStack {
                    if settings.enableSounds {
                        Image(systemName: "speaker.wave.2.fill")
                            .frame(width: 20, height: 20, alignment: .center)
                        Text("Sounds Enabled")
                            .font(.footnote)
                    } else {
                        Image(systemName: "speaker.slash.fill")
                            .frame(width: 20, height: 20, alignment: .center)
                        Text("Sounds Disabled")
                            .font(.footnote)
                    }
                }
                .foregroundColor(settings.enableSounds ? .white : .gray)
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.init(white: 0.05))
                .cornerRadius(8)
            }
            // NOTIFICATIONS BUTTON
            Button(action: {
                withAnimation {
                    settings.enableNotification.toggle()
                }
            }) {
                HStack {
                    if settings.enableNotification {
                        Image(systemName: "bell.badge.fill")
                            .frame(width: 20, height: 20, alignment: .center)
                        Text("Notifications Enabled")
                            .font(.footnote)
                    } else {
                        Image(systemName: "bell.slash.fill")
                            .frame(width: 20, height: 20, alignment: .center)
                        Text("Notifications Disabled")
                            .font(.footnote)
                    }
                }
                .foregroundColor(settings.enableNotification ? .white : .gray)
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.init(white: 0.05))
                .cornerRadius(8)
            }
        }
    }
}

private struct SettingsItem: View {
    
    let buttonAction: () -> ()
    @Binding var switchVar: Bool
    
    var body: some View {
        Button(action: buttonAction) {
            HStack {
                if switchVar {
                    Image(systemName: "arrow.up.heart.fill")
                        .frame(width: 20, height: 20, alignment: .center)
                    Text("Safe to Apple Health Enabled")
                        .font(.footnote)
                } else {
                    Image(systemName: "heart.slash.fill")
                        .frame(width: 20, height: 20, alignment: .center)
                    Text("Safe to Apple Health Disabled")
                        .font(.footnote)
                }
            }
            .foregroundColor(switchVar ? .white : .gray)
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.init(white: 0.05))
            .cornerRadius(8)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    @Namespace static var namespace
    @StateObject static var settings = Settings()
    
    static var previews: some View {
        HomeView(namespace: namespace, showTimerView: Binding.constant(false), activeTimer: Binding.constant(ActiveTimer(durationInMinutes: 7)))
            .preferredColorScheme(.dark)
            .environmentObject(settings)
    }
}
