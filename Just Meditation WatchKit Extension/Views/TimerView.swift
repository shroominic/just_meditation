//
//  TimerView.swift
//  Just Meditation
//
//  Created by Fungus on 05.07.22.
//

import SwiftUI


struct TimerView: View {
    @EnvironmentObject var settings: Settings
    let namespace: Namespace.ID
    
    @Binding var activeTimer: ActiveTimer
    @Binding var showTimer: Bool
    @StateObject var viewModel = TimerViewModel()
    
    init(_ namespace: Namespace.ID, activeTimer: Binding<ActiveTimer>, showTimerView: Binding<Bool>) {
        self.namespace = namespace
        self._activeTimer = activeTimer
        self._showTimer = showTimerView
    }
    
    var body: some View {
        if !viewModel.timerFinished {
            VStack {
                // Timer View
                HStack{
                    Text(viewModel.timerString())
                        .font(.system(size: 69, weight: .ultraLight, design: .rounded))
                }
                // Buttons
                TimerButtonRow(namespace, activeTimer: $activeTimer, timerRunning: $viewModel.timerRunning, stop_button: { viewModel.stopButton() })
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            // every second tick
            .onReceive(viewModel.timer) { time in
                viewModel.tick()
            }
            // when timer starts
            .onAppear() {
                self.viewModel.activeTimer = activeTimer
                viewModel.startTimer()
            }
        } else {
            VStack {
                Text("You completed \(viewModel.minutesCompleted())")
                    .frame(maxHeight: .infinity, alignment: .center)
                Text("FINISH")
                    .frame(height: 28)
                    .padding()
                    .font(.system(size: 20, weight: .light, design: .monospaced))
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white, lineWidth: 1)
                            .matchedGeometryEffect(id: "buttonCase", in: namespace)
                    )
                    .onTapGesture {
                        viewModel.finishButton()
                        // close finished timer view
                        withAnimation {
                            showTimer.toggle()
                        }
                    }
            }
        }
    }
}


private struct TimerButtonRow: View {
    @EnvironmentObject var settings: Settings
    let namespace: Namespace.ID
        
    @Binding var activeTimer: ActiveTimer
    @Binding var timerRunning: Bool
    
    var stopButton: () -> Void
    
    init(_ namespace: Namespace.ID, activeTimer: Binding<ActiveTimer>, timerRunning: Binding<Bool>, stop_button: @escaping () -> Void) {
        self.namespace = namespace
        self._activeTimer = activeTimer
        self._timerRunning = timerRunning
        self.stopButton = stop_button
    }
    
    var body: some View {
        if !timerRunning {
            HStack {
                Image(systemName: "play")
                    .frame(width: 20, height: 20)
                    .padding(20)
                    .foregroundColor(.white)
                    .offset(x: 22)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7, blendDuration: 1)) {
                            timerRunning.toggle()
                        }
                    }
                Image(systemName: "stop")
                    .frame(width: 20, height: 20)
                    .foregroundColor(.red)
                    .padding(8)
                    .offset(x: 8)
                    .onTapGesture(perform: stopButton)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white, lineWidth: 1)
                    .matchedGeometryEffect(id: "buttonCase", in: namespace)
                    .offset(x: 22)
            )
        } else {
            Image(systemName: "pause")
                .frame(width: 20, height: 20)
                .padding(20)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white, lineWidth: 1)
                        .matchedGeometryEffect(id: "buttonCase", in: namespace)
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.7, blendDuration: 1)) {
                        timerRunning.toggle()
                    }
                }
        }
    }
}


struct TimerView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        TimerView(namespace, activeTimer: Binding.constant(ActiveTimer()), showTimerView: Binding.constant(true))
            .preferredColorScheme(.dark)
            .environmentObject(Settings())
    }
}
