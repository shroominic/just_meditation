//
//  just_meditation.swift
//  Just Meditation
//
//  Created by Fungus on 12.07.22.
//

import SwiftUI

struct just_meditation: View {
    @Namespace var namespace
    var mode: String
    
    var body: some View {
        ZStack {
            switch mode
            {
            case "just":
                HStack{
                    Text("just")
                        .foregroundColor(.init(white: 0.4))
                        
                    Text("meditation")
                        .foregroundColor(.init(white: 0.3))
                }
                .font(.system(size: 16, weight: .light, design: .monospaced))
                .frame(maxHeight: .infinity, alignment: .top)
            case "meditation":
                HStack{
                    Text("just")
                        .foregroundColor(.init(white: 0.3))
                        
                    Text("meditation")
                        .foregroundColor(.init(white: 0.4))
                }
                .font(.system(size: 16, weight: .light, design: .monospaced))
                .frame(maxHeight: .infinity, alignment: .top)
            default:
                Text("mode not found")
            }
        }
    }
}

struct just_meditation_Previews: PreviewProvider {
    static var previews: some View {
        just_meditation(mode: "meditation")
            .preferredColorScheme(.dark)
    }
}
