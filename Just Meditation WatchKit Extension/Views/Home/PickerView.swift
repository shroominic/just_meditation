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
            Text("MIN")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.gray)
                .frame(width: 60, height: 30)
                .hidden()
            Picker("DURATION", selection: $duration, content: {
                ForEach(1...60, id: \.self) {i in
                    Text("\(i)").tag(i)
                        .font(.system(size: 20, weight: .light))
                }
            })
            .pickerStyle(.wheel)
            .labelsHidden()
            .frame(width: 42, height: 64)
            
            .padding(.horizontal)
            Text("MIN")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.gray)
                .frame(width: 60, height: 30, alignment: .leading)
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
