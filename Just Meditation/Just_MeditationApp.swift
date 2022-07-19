//
//  Just_MeditationApp.swift
//  Just Meditation
//
//  Created by Fungus on 04.07.22.
//

import SwiftUI

@main
struct Just_MeditationApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.dark)
        }
    }
}

struct JustMeditation_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
            .previewDevice("Apple Watch Series 7 - 41mm")
    }
}
