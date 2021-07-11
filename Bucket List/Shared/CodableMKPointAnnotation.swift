//
//  CodableMKPointAnnotation.swift
//  Bucket List
//
//  Created by bytedance on 2021/7/11.
//

import Foundation
import MapKit

class CodableMKPointAnnotation: MKPointAnnotation, Codable {
    enum CodingKeys: CodingKey {
        case title, subtitile, latitude, longitude
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else { return }
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decode(String.self, forKey: .subtitile)
        coordinate = CLLocationCoordinate2D()
        coordinate.latitude = try container.decode(Double.self, forKey: .latitude)
        coordinate.longitude = try container.decode(Double.self, forKey: .longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(wrappedTitle, forKey: .title)
        try container.encode(wrappedSubtitle, forKey: .subtitile)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}
