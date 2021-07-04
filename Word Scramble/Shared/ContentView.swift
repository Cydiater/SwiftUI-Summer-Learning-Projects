//
//  ContentView.swift
//  Shared
//
//  Created by bytedance on 2021/6/23.
//

import SwiftUI

struct ContentView: View {
    @State private var rootWord = "liverpool"
    @State private var newWord = ""
    @State private var usedWords = [String]()
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    func randomRootWord() {
        let path = Bundle.main.url(forResource: "start", withExtension: "txt")
        var words = [String]()
        do {
            let text = try String(contentsOf: path!, encoding: String.Encoding.utf8)
            words = text.components(separatedBy: .whitespacesAndNewlines)
        } catch {
            fatalError("cannot load raw text")
        }
        guard words.count > 0 else {
            fatalError("empty word list")
        }
        rootWord = words.shuffled()[0]
    }
    
    func showAlert(alertTitle: String, alertMessage: String) {
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        showingAlert = true
    }
    
    func isOriginal(_ word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isLegal(_ word: String) -> Bool {
        var tempWord = rootWord
        for char in word {
            let index = tempWord.firstIndex(of: char)
            if index == nil {
                return false
            }
            tempWord.remove(at: index!)
        }
        return true
    }
    
    func isReal(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func useWord() {
        
        guard isOriginal(newWord) else {
            showAlert(alertTitle: "Try again", alertMessage: "This word is not original")
            return
        }
        
        guard isLegal(newWord) else {
            showAlert(alertTitle: "Try again", alertMessage: "This word is illegal")
            return
        }
        
        guard isReal(newWord) else {
            showAlert(alertTitle: "Try again", alertMessage: "This word is not real")
            return
        }
        
        usedWords.insert(newWord, at: 0)
        newWord = ""
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Scramble this word", text: $newWord, onCommit: useWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                    .alert(isPresented: $showingAlert, content: {
                        Alert(title: Text(alertTitle), message: Text(alertMessage))
                    })
                List {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onAppear(perform: randomRootWord)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
