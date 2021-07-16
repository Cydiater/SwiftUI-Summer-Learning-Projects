//
//  CardView.swift
//  Flashzilla
//
//  Created by bytedance on 2021/7/16.
//

import SwiftUI

struct Card: Identifiable, Codable {
    var id = UUID()
    var prompt: String
    var answer: String
    
    static var example: Card {
        return Card(prompt: "What's the biggest country in the world?", answer: "China")
    }
    
    static var examples: [Card] {
        return [Card](repeating: example, count: 5)
    }
}

struct CardView: View {
    var card: Card
    var removel: (() -> Void)? = nil
    let generator = UISelectionFeedbackGenerator()
    @State private var showingAnswer = false
    @State private var offset: CGSize = .zero
    @State private var angle: Angle = .zero
    @State private var color: Color = .white
    @State private var opacity: Double = 1
    @State private var decided = false
    
    var CardSwipeGesture: some Gesture {
        return DragGesture()
            .onChanged { ges in
                generator.prepare()
                offset.width = ges.translation.width * 1.5
                angle.degrees = Double(ges.translation.width / 200 * 10)
                if ges.translation.width < 0 {
                    color = .green
                } else if ges.translation.width > 0 {
                    color = .red
                } else {
                    color = .white
                }
                opacity = Double(2.0 - abs(ges.translation.width / 100))
                if opacity < 1 && decided == false {
                    decided = true
                    generator.selectionChanged()
                }
                if opacity >= 1 && decided == true {
                    decided = false
                }
            }
            .onEnded { _ in
                if opacity < 1 {
                    removel?()
                }
                withAnimation {
                    offset = .zero
                    angle = .zero
                    color = .white
                    opacity = 1
                    decided = false
                }
            }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(color)
                .shadow(radius: 10)
            VStack {
                Text(card.prompt)
                    .font(.title)
                    .multilineTextAlignment(.center)
                if showingAnswer {
                    Text(card.answer)
                        .font(.title2)
                        .padding()
                }
            }
        }
        .opacity(opacity)
        .frame(width: 450, height: 230)
        .onTapGesture {
            showingAnswer = true
        }
        .offset(offset)
        .rotationEffect(angle)
        .gesture(CardSwipeGesture)
    }
}

struct LandscapeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .previewLayout(.fixed(width: 812, height: 375))
            .environment(\.horizontalSizeClass, .compact)
            .environment(\.verticalSizeClass, .compact)
    }
}

extension View {
    func landscape() -> some View {
        self.modifier(LandscapeModifier())
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
            .landscape()
    }
}
