//
//  Resort.swift
//  SnowSeeker
//
//  Created by bytedance on 2021/7/22.
//

import Foundation

struct Resort: Identifiable, Codable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]
}

extension Bundle {
    func loadJSON<T: Decodable>(from filename: String) -> T {
        guard let url = url(forResource: filename, withExtension: nil) else {
            fatalError("Failed to parse URL")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load data")
        }
        
        guard let obj = try? JSONDecoder().decode(T.self, from: data) else {
            fatalError("Failed to parse data")
        }
        
        return obj
    }
}
