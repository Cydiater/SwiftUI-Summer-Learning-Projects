//
//  ContentView.swift
//  Shared
//
//  Created by bytedance on 2021/7/13.
//

import SwiftUI

struct Prospect: Identifiable, Codable {
    var id = UUID()
    var name: String
    var email: String
    var isContacted: Bool = false
}

class Prospects: ObservableObject {
    @Published var peoples: [Prospect]
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "prospects") {
            do {
                self.peoples = try JSONDecoder().decode([Prospect].self, from: data)
                return
            } catch {
                print("Failed to restore data from UserDefault")
            }
        }
        peoples = [Prospect]()
    }
    
    func save() {
        guard let data = try? JSONEncoder().encode(peoples) else {
            print("Failed to save data to UserDefault")
            return
        }
        UserDefaults.standard.setValue(data, forKey: "prospects")
    }
    
    static var example: Prospects {
        let p = Prospects()
        let prospect = Prospect(name: "Kinfee", email: "cydiater@gmail.com")
        p.peoples.append(prospect)
        return p
    }
    
    func toggleContact(_ prospect: Prospect) {
        objectWillChange.send()
        if let index = peoples.firstIndex(where: {$0.id == prospect.id}) {
            peoples[index].isContacted.toggle()
        }
        save()
    }
}

enum ProspectFilter {
    case none, contacted, uncontacted
}

struct ContentView: View {
    var prospects = Prospects()
    
    var body: some View {
        TabView {
            ProspectView(prospectFilter: .none)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Everyone")
                }
            ProspectView(prospectFilter: .contacted)
                .tabItem {
                    Image(systemName: "person.fill.checkmark")
                    Text("Contacted")
                }
            ProspectView(prospectFilter: .uncontacted)
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Uncontacted")
                }
            MeView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Me")
                }
        }
        .environmentObject(prospects)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
