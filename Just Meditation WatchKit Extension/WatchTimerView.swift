//
//  WatchTimerView.swift
//  Just Meditation WatchKit Extension
//
//  Created by Fungus on 08.07.22.
//

import SwiftUI

struct WatchTimerView: View {
    @State private var timeRemaining: Int
    @Binding var showTimerView: Bool
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var displayTimer: String {
        return String(format:"%d:%02d", timeRemaining/60, timeRemaining%60)}
    
    init(minutes: Int, showTimerView: Binding<Bool>) {
        self._timeRemaining = State(initialValue: minutes*60)
        self._showTimerView = showTimerView
    }
    
    var body: some View {
        VStack {
            HStack{
                Text(displayTimer)
            }
            HStack {
                Button(action: {
                    withAnimation {
                        showTimerView.toggle()
                    }
                }){
                    Image(systemName: "stop")
                        .padding(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.white, lineWidth: 1)
                        )
                        .foregroundColor(.white)
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .onReceive(timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                onFinish()
            }
        }
    }
    
    func onFinish() {
        
    }
}

struct WatchTimerView_Previews: PreviewProvider {
    
    @State static var showTimerView: Bool = false
    
    static var previews: some View {
        WatchTimerView(minutes: 7, showTimerView: $showTimerView)
    }
}
