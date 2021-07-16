//
//  ClockView.swift
//  Flashzilla
//
//  Created by bytedance on 2021/7/16.
//

import SwiftUI

struct ClockView: View {
    @Binding var secondAmount: Int
    @Binding var isActive: Bool
    
    let clock = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
        
    var body: some View {
        ZStack {
            Color.blue
            HStack {
                Image(systemName: isActive ? "hourglass" : "play.fill")
                Spacer()
                Text(String(secondAmount))
                    .onReceive(clock, perform: { _ in
                        guard isActive else { return }
                        guard secondAmount > 0 else { return }
                        secondAmount -= 1
                        if secondAmount == 0 {
                            isActive = false
                        }
                    })
            }
            .padding()
            .foregroundColor(.white)
            .font(.title2)
            .onTapGesture(perform: {
                guard !isActive else { return }
                isActive = true
            })
        }
        .frame(width: 100, height: 50)
        .clipShape(Capsule())
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        ClockView(secondAmount: .constant(120), isActive: .constant(false))
            .landscape()
    }
}
