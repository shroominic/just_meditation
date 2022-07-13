//
//  ActiveTimer.swift
//  Just Meditation
//
//  Created by Fungus on 09.07.22.
//

import Foundation
import AVFoundation


var player: AVAudioPlayer!
let formatter = DateComponentsFormatter()


func playSound(sound_name: String) {
    let url = Bundle.main.url(forResource: sound_name, withExtension: "wav")
    
    guard url != nil else {
        print("error inside guard")
        return
    }
    do {
        player = try AVAudioPlayer(contentsOf: url!)
        player?.play()
    } catch {
        print("error")
    }
}


class ActiveTimer: ObservableObject {
    let id = UUID()
    
    var startDate: Date
    var endDate: Date
    
    func alreadyMeditated(dateNow: Date) -> String {
        return formatter.string(from: startDate.distance(to: dateNow))!
    }
    
    func toString(dateNow: Date) -> String {
        return formatter.string(from: dateNow.distance(to: self.endDate))!
    }

    init(durationInMinutes: Int = 7) {
        self.startDate = Date()
        self.endDate = Date() + TimeInterval(60*durationInMinutes + 2)
    }
    
    func onStart(soundsEnabled: Bool) {
        // play some start vibration
        // vibrate()
        if soundsEnabled {
            playSound(sound_name: "tibetan_gong_start")
        }
    }
    
    func finish(soundsEnabled: Bool) {
        // play some finish vibration
        // vibrate()
        if soundsEnabled {
            playSound(sound_name: "tibetan_gong_finish")
        }
    }
    
    
}
