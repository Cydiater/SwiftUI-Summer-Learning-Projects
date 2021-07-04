//
//  Mission.swift
//  Moonshot
//
//  Created by bytedance on 2021/6/29.
//

import Foundation

struct Mission: Codable, Identifiable {
    struct CrewMember: Codable {
        let name: String
        let role: String
    }
    
    let id: Int
    let crew: [CrewMember]
    let launchDate: Date?
    let description: String
    
    var missionName: String {
        return "Apollo \(id)"
    }
    
    var imageName: String {
        return "apollo\(id)"
    }
    
    var formatedDate: String {
        if let launchDate = launchDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: launchDate)
        } else {
            return "N/A"
        }
    }
}
