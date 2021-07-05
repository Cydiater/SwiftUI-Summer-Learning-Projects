//
//  RatingView.swift
//  Bookworm
//
//  Created by bytedance on 2021/7/4.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}

struct RatingView: View {
    @Binding var rating: Int16
    var upperBound = 5
    var fillColor = Color.yellow
    var font = Font.body
    var noTap = true
    
    var body: some View {
        HStack {
            ForEach(1 ..< upperBound + 1) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundColor(fillColor)
                    .font(font)
                    .if(!noTap) {
                        $0.onTapGesture {
                            rating = Int16(index)
                        }
                    }
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(3))
            
    }
}
