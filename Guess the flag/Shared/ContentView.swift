//
//  ContentView.swift
//  Shared
//
//  Created by bytedance on 2021/6/19.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0 ..< 3)
    @State private var selectedAnswer = 0
    @State private var score = 0
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack {
                Text("Guess the flag of").foregroundColor(.white)
                Text("\(countries[correctAnswer])").font(.largeTitle).foregroundColor(.white).bold()
                VStack(spacing: 20) {
                    ForEach(0 ..< 3) { number in
                        Button(action: {
                            flagTapped(number)
                        }) {
                            Image(countries[number])
                        }
                    }
                }
                Text("Total score: \(score)").foregroundColor(.white)
            }
            .alert(isPresented: $showingAlert, content: {
                Alert(title: selectedAnswer == correctAnswer ? Text("Correct") : Text("Wrong"), message: Text("Try next?"), dismissButton: .default(Text("OK")) {
                    countries.shuffle()
                    correctAnswer = Int.random(in: 0 ..< 3)
                })
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
        }
        selectedAnswer = number
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
