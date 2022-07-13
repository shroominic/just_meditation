//
//  ContentView.swift
//  Just Meditation WatchKit Extension
//
//  Created by Fungus on 04.07.22.
//

import SwiftUI

struct WatchHomeView: View {
    
    @State var duration: Int = 7
    @State var showTimerView: Bool = false
    
    var body: some View {
        if showTimerView {
            WatchTimerView(minutes: duration, showTimerView: $showTimerView)
        } else {
            VStack {
                HStack {
                    Picker(selection: $duration, label:
                        Text("DURATION")
                            .font(.system(size: 10, weight: .ultraLight, design: .monospaced))
                    ) {
                        ForEach(1...137, id: \.self) {i in
                            Text("\(i)").tag(i)
                                .font(.system(size: 14, weight: .light))
                        }
                    }
                    .padding(.horizontal)
                    //.frame(width: 40, height: 80)
                    
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(Color.init(white: 0.03))
                .cornerRadius(12)
                
                HStack {
                    Button(action: {
                        withAnimation {
                            showTimerView.toggle()
                        }
                    }){
                        Image(systemName: "play")
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.white, lineWidth: 1)
                            )
                            .foregroundColor(.white)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
    
    func timerStep() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WatchHomeView()
    }
}
