//
//  ContentView.swift
//  Shared
//
//  Created by bytedance on 2021/7/22.
//

import SwiftUI

class LikeMap: ObservableObject {
    var map: [String: Any]
    
    init() {
        if let map = UserDefaults.standard.dictionary(forKey: "LikeMap") {
            self.map = map
        } else {
            map = [String: Any]()
        }
    }
    
    func set(id: String, withValue value: Bool) {
        objectWillChange.send()
        map[id] = value
        save()
    }
    
    func get(id: String) -> Bool {
        return map[id] as? Bool ?? false
    }
    
    func save() {
        UserDefaults.standard.setValue(map, forKey: "LikeMap")
    }
}

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.loadJSON(from: "resorts.json")
    @ObservedObject var likeMap: LikeMap = LikeMap() // TODO: load from UserDefault
    
    var body: some View {
        NavigationView {
            List(resorts) { resort in
                return NavigationLink(destination: ResortView(resort: resort)) {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .frame(width: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        if likeMap.get(id: resort.id) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationBarTitle("SnowSeeker")
            WelcomView()
        }
        .environmentObject(likeMap)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
