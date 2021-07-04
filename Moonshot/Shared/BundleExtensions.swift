//
//  BundleExtensions.swift
//  Moonshot
//
//  Created by bytedance on 2021/6/29.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ fileName: String) -> T {
        guard let url = url(forResource: fileName, withExtension: nil) else {
            fatalError("cannot locate url for \(fileName)")
        }
        
        guard let text = try? String(contentsOf: url) else {
            fatalError("cannot load text from \(url)")
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        guard let obj = try? decoder.decode(T.self, from: Data(text.utf8)) else {
            fatalError("cannot decode json from \(text)")
        }
        
        return obj
    }
}
