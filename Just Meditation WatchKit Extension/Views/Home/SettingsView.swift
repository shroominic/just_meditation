//
//  SettingsView.swift
//  Just Meditation
//
//  Created by Fungus on 09.07.22.
//

import SwiftUI
import HealthKit
import UserNotifications


struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    var namespace: Namespace.ID
    
    @State var showMore: Bool = false
    @State private var showView: SettingViews = .switches
    
    @State var showNotificationAlert: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                // SETTING PAGES
                HStack(alignment: .bottom) {
                    switch showView {
                    case .infos:
                        InfoView()
                    case .switches:
                        SettingsSwitchPage(showNotificationAlert: $showNotificationAlert)
                    }
                }
                // SETTING NAVIGATION
                VStack(alignment: .trailing) {
                    // SWITCHES
                    Image(systemName: "gear")
                        .rotationEffect(Angle(degrees: 180))
                        .frame(width: 25, height: 25)
                        .matchedGeometryEffect(id: "settingsgear", in: namespace)
                        .foregroundColor((self.showView == .switches) ? .white : .gray)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.7, blendDuration: 1)) {
                                showView = .switches
                            }
                        }
                    
                    // SHOW INFO BUTTON
                    Image(systemName: "info.circle")
                        .padding(.vertical, 5)
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor(self.showView == .infos ? .white : .gray)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.7, blendDuration: 1)) {
                                showView = .infos
                            }
                        }
                }
            }
        }
        .padding(5)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.white, lineWidth: 1)
        )
        .padding(.horizontal)
        .offset(y: 6)
        .background(.black)
    }
}

private enum SettingViews {
    case infos
    case switches
}

private struct SettingsSwitchPage: View {
    @EnvironmentObject var settings: Settings
    @Binding var showNotificationAlert: Bool
    
    var body: some View {
        VStack {
            HStack {
                // APPLE HEALTH BUTTON
                SettingsItem(
                    label: "Safe Data",
                    buttonAction: {
                        if settings.healthSyncEnabled {
                            withAnimation {
                                settings.healthSyncEnabled.toggle()
                                settings.saveData()
                            }
                        } else {
                            withAnimation {
                                activateHealthKit()
                            }
                        }},
                    systemIcons: ("arrow.up.heart.fill", "heart.slash.fill"),
                    switchVar: $settings.healthSyncEnabled)
                // SOUNDS BUTTON
                SettingsItem(
                    label: "Sounds",
                    buttonAction: {
                        withAnimation {
                            settings.soundsEnabled.toggle()
                            settings.saveData()
                        }
                    },
                    systemIcons: ("speaker.wave.2.fill", "speaker.slash.fill"),
                    switchVar: $settings.soundsEnabled)
                // NOTIFICATIONS BUTTON
                SettingsItem(
                    label: "Notifications",
                    buttonAction: {
                        withAnimation {
                            toggleNotifications()
                            settings.saveData()
                        }
                    },
                    systemIcons: ("bell.badge.fill", "bell.slash.fill"),
                    switchVar: $settings.notificationEnabled)
                .alert("Please activate your notifications first.", isPresented: $showNotificationAlert) {
                            Button("OK", role: .cancel) { }
                        }
            }
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
    
    func toggleNotifications() {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { permission in
            switch permission.authorizationStatus  {
            // all permissions authorized
            case .authorized:
                print("authorized")
                DispatchQueue.main.async {
                    settings.notificationEnabled.toggle()
                    settings.saveData()
                }
            // The app isn't authorized to schedule or receive notifications.
            case .denied:
                print("User denied notification permission")
                DispatchQueue.main.async {
                    settings.notificationEnabled = false
                    settings.saveData()
                    showNotificationAlert.toggle()
                }
            // notification permission haven't been asked yet
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                        DispatchQueue.main.async {
                            settings.notificationEnabled = true
                            settings.saveData()
                        }
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            case .provisional:
                // @available(iOS 12.0, *)
                print("The application is authorized to post non-interruptive user notifications.")
            case .ephemeral:
                // @available(iOS 14.0, *)
                print("The application is temporarily authorized to post notifications. Only available to app clips.")
            @unknown default:
                print("Unknow Status")
            }
        })
    }
    
    
    func activateHealthKit() {
        let healthStore = HKHealthStore()
        
        let typestoRead = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
        ])
        
        let typestoShare = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
        ])
        
        healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
            if success == false {
                DispatchQueue.main.async {
                    settings.healthSyncEnabled = false
                    settings.saveData()
                }
                print("solve this error\(String(describing: error))")
                NSLog(" Display not allowed")
            }
            if success == true {
                DispatchQueue.main.async {
                    settings.healthSyncEnabled = true
                    settings.saveData()
                }
                print("dont worry everything is good \(success)")
                NSLog(" Integrated SuccessFully")
            }
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
                .cornerRadius(8)
            }
        }
    }
}


private struct InfoView: View {
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    var body: some View {
        HStack(alignment: .top) {
            ScrollView {
                Text("""
                    Thanks for using just meditation
                    and I hope it helped you become sharp and clear again!
                    
                    If you want to support me just leave a rating in the AppStore.
                    
                    socials:
                    [linktr.ee/shroominic](https://linktr.ee/shroominic)
                    """)
                    .font(.system(size: 8, weight: .light, design: .monospaced))
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
        HomeView(namespace, showTimerView: Binding.constant(false), activeTimer: Binding.constant(ActiveTimer(durationInMinutes: 7)))
            .preferredColorScheme(.dark)
            .environmentObject(settings)
            
    }
}
