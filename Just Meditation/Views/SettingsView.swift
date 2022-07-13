//
//  SettingsView.swift
//  Just Meditation
//
//  Created by Fungus on 09.07.22.
//

import SwiftUI



struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    var namespace: Namespace.ID
    
    @State var showMore: Bool = false
    @State var showInfoView: Bool = false
    
    var body: some View {
        ZStack {

            if showMore {
                HStack {
                    if showInfoView {
                        InfoView()
                            .padding(.horizontal)
                    }
                    VStack {
                        // CLOSE SETTINGS BUTTON
                        Button(action: {
                            withAnimation {
                                showMore.toggle()
                                showInfoView = false
                            }
                        }){
                            Image(systemName: "chevron.up.circle")
                                .rotationEffect(Angle(degrees: 180))
                                .frame(width: 34, height: 34, alignment: .center)
                                .matchedGeometryEffect(id: "settingsgear", in: namespace)
                                .foregroundColor(.white)
                        }
                        // APPLE HEALTH BUTTON
                        SettingsItem(
                            label: "Safe Data",
                            buttonAction: {
                                if settings.healthKitActivated {
                                    withAnimation {
                                        settings.healthKitActivated.toggle()
                                    }
                                } else {
                                    withAnimation {
                                        settings.activateHealthKit()
                                    }
                                }},
                            systemIcons: ("arrow.up.heart.fill", "heart.slash.fill"),
                            switchVar: $settings.healthKitActivated)
                        // SOUNDS BUTTON
                        SettingsItem(
                            label: "Sounds",
                            buttonAction: {
                                withAnimation {
                                    settings.enableSounds.toggle()
                                }
                            },
                            systemIcons: ("speaker.wave.2.fill", "speaker.slash.fill"),
                            switchVar: $settings.enableSounds)
                        // NOTIFICATIONS BUTTON
                        SettingsItem(
                            label: "Notifications",
                            buttonAction: {
                                withAnimation {
                                    settings.enableNotification.toggle()
                                }
                            },
                            systemIcons: ("bell.badge.fill", "bell.slash.fill"),
                            switchVar: $settings.enableNotification)

                        // SHOW INFO BUTTON
                        Button(action: {
                            withAnimation {
                                showInfoView.toggle()
                            }
                        }) {
                            Image(systemName: "info.circle")
                                .padding(.vertical, 5)
                                .foregroundColor(showInfoView ? .white : .gray)
                        }
                        
                    }
                }
            } else {
                // SETTINGS BUTTON
                Button(action: {
                    withAnimation {
                        showMore.toggle()
                    }
                }){
                    Image(systemName: "chevron.up.circle")
                        .rotationEffect(Angle(degrees: 0))
                        .frame(width: 34, height: 34, alignment: .center)
                        .matchedGeometryEffect(id: "settingsgear", in: namespace)
                        .foregroundColor(.gray)
                }
            }

                
            
        }
        .padding(5)
        .background(Color.init(white: 0.1))
        .cornerRadius(8)
//        .background(.black)
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(.white, lineWidth: 1)
//                .matchedGeometryEffect(id: "settings", in: namespace)
//        )
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.black)
        
    }
    
    enum Views {
        case hidden
        case icons
        case settings
        case info
    }
}

private struct SettingsItem: View {
    
    let label: String
    let buttonAction: () -> ()
    var systemIcons: (String, String)

    @Binding var switchVar: Bool
    
    
    var body: some View {
        Button(action: buttonAction) {
            VStack {
                Image(systemName: switchVar ? systemIcons.0 : systemIcons.1)
                    .frame(width: 25, height: 25, alignment: .center)
            }
            .padding(5)
            .foregroundColor(switchVar ? .accentColor : .gray)
            .background(Color.init(white: 0.05))
            .cornerRadius(8)
        }
    }
}

private struct InfoView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    var body: some View {
        HStack(alignment: .top) {
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
        }
    }
    
}

private struct SettingsView_Previews: PreviewProvider {
    @Namespace static var namespace
    @StateObject static var settings = Settings()
    
    static var previews: some View {
        HomeView(namespace: namespace, showTimerView: Binding.constant(false), activeTimer: Binding.constant(ActiveTimer(durationInMinutes: 7)))
            .preferredColorScheme(.dark)
            .environmentObject(settings)
    }
}
