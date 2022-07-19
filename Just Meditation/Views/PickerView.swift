//
//  PickerView.swift
//  Just Meditation
//
//  Created by Fungus on 18.07.22.
//

import SwiftUI

struct PickerView: View {
    
    @Binding var duration: Int
    
    var body: some View {
        HStack {
            Text("DURATION")
                .font(.system(size: 24, weight: .ultraLight, design: .monospaced))
            Picker("DURATION", selection: $duration, content: {
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
            .labelsHidden()
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

    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView(duration: Binding.constant(7))
    }
}
