//
//  ContentView.swift
//  Shared
//
//  Created by bytedance on 2021/7/16.
//

import SwiftUI

extension View {
    func stacked(at index: Int, in total: Int) -> some View {
        let offset = CGFloat(total - index) * 5
        return self.offset(x: 0, y: offset)
    }
}

struct ContentView: View {
    @State private var cards = [Card]()
    @State private var secondsAmount: Int = 120
    @State private var isActive = false
    @State private var showingEditView = false
    
    func removeCard(_ index: Int) {
        cards.remove(at: index)
    }
        
    func reset() {
        secondsAmount = 120
        isActive = false
        if let data = UserDefaults.standard.data(forKey: "cards.json") {
            do {
                cards = try JSONDecoder().decode([Card].self, from: data)
            } catch {
                print("Failed to load stored data")
            }
        }
    }
    
    var body: some View {
        ZStack {
            Image("background")
            VStack {
                HStack {
                    ClockView(secondAmount: $secondsAmount, isActive: $isActive)
                    Button(action: {
                        showingEditView.toggle()
                    }) {
                        ZStack {
                            Color.blue
                            Text("Edit")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                        .frame(width: 100, height: 50)
                        .clipShape(Capsule())
                    }
                    .sheet(isPresented: $showingEditView, onDismiss: {
                        reset()
                    }, content: {
                        EditView()
                    })
                    Button(action: {
                        reset()
                    }) {
                        ZStack {
                            Color.blue
                            Text("Reset")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                        .frame(width: 100, height: 50)
                        .clipShape(Capsule())
                    }
                }
                .padding()

                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index], removel: {
                            withAnimation {
                                self.removeCard(index)
                            }
                        })
                            .stacked(at: index, in: cards.count)
                    }
                }
                .allowsHitTesting(isActive)
                .padding()
            }
        }
        .onAppear(perform: reset)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .landscape()
            .padding()
    }
}
