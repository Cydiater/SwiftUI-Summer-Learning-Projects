//
//  ProspectView.swift
//  Hot Prospect
//
//  Created by bytedance on 2021/7/13.
//

import SwiftUI
import CodeScanner
import UserNotifications

extension String: Error {} // Enables you to throw a string

extension String: LocalizedError { // Adds error.localizedDescription to Error instances
    public var errorDescription: String? { return self }
}


struct ProspectView: View {
    var prospectFilter: ProspectFilter
    @EnvironmentObject var prospects: Prospects
    @State private var showingScanner = false
    
    var title: String {
        switch prospectFilter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted"
        case .uncontacted:
            return "Contact Later"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch prospectFilter {
        case .none:
            return prospects.peoples
        case .contacted:
            return prospects.peoples.filter({ $0.isContacted == true })
        case .uncontacted:
            return prospects.peoples.filter({ $0.isContacted == false })
        }
    }
    
    func addNewProspect(from info: String) throws {
        let lines = info.split(separator: "\n")
        guard lines.count == 2 else {
            throw "Format Error: not 2 lines"
        }
        let name = String(lines[0])
        let email = String(lines[1])
        let prospect = Prospect(name: name, email: email)
        prospects.peoples.append(prospect)
        prospects.save()
    }
    
    func ScheduleNotification(_ prospect: Prospect, after: Double) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .announcement], completionHandler: { success, error in
            if success {
                let content = UNMutableNotificationContent()
                content.title = "Contact \(prospect.name)"
                content.subtitle = prospect.email
                content.sound = .default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: after, repeats: false)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            } else if let error = error {
                print(error.localizedDescription)
            }
        })

    }
    
    var body: some View {
        NavigationView {
            List(filteredProspects, id: \.id) { prospect in
                VStack(alignment: .leading) {
                    Text(prospect.name)
                        .font(.headline)
                    Text(prospect.email)
                        .font(.subheadline)
                }
                .contextMenu(ContextMenu(menuItems: {
                    Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted") {
                        prospects.toggleContact(prospect)
                    }
                    if !prospect.isContacted {
                        Button("Remind me later") {
                            ScheduleNotification(prospect, after: 5)
                        }
                    }
                }))
            }
            .navigationTitle(title)
            .navigationBarItems(trailing: Button(action: {
                showingScanner.toggle()
            }) {
                Image(systemName: "qrcode.viewfinder")
            })
        }
        .sheet(isPresented: $showingScanner, content: {
            CodeScannerView(codeTypes: [.qr]) { result in
                switch result {
                case .success(let code):
                    do {
                        try addNewProspect(from: code)
                    } catch {
                        print("Failed to add prospect.")
                    }
                    showingScanner.toggle()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        })
    }
}

struct ProspectView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectView(prospectFilter: .none)
            .environmentObject(Prospects.example)
    }
}
