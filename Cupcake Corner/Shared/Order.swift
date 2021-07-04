//
//  Order.swift
//  Cupcake Corner
//
//  Created by bytedance on 2021/7/3.
//

import Foundation

enum CupcakeType: String, CaseIterable, Codable, Identifiable {
    case strawberry
    case chocolate
    case vanllia
    
    var id: String {
        self.rawValue
    }
}

class Order: ObservableObject, Codable {
    @Published var cupcakeType: CupcakeType = .vanllia
    @Published var orderAmount: Int = 0
    @Published var specialRequirement: Bool = false {
        didSet {
            if specialRequirement == false {
                moreFrost = false
                moreSprinkle = false
            }
        }
    }
    @Published var moreFrost: Bool = false
    @Published var moreSprinkle: Bool = false
    
    @Published var name = ""
    @Published var city = ""
    @Published var street = ""
    @Published var zip = ""
    
    var validAddress: Bool {
        return name.count > 0 && city.count > 0 && street.count > 0 && zip.count > 0
    }
    
    enum CodingKeys: String, CodingKey {
        case cupcakeType
        case orderAmount
        case specialRequirement
        case moreFrost
        case moreSprinkle
        case name
        case city
        case street
        case zip
    }
    
    init() { }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cupcakeType = try container.decode(CupcakeType.self, forKey: CodingKeys.cupcakeType)
        orderAmount = try container.decode(Int.self, forKey: CodingKeys.orderAmount)
        specialRequirement = try container.decode(Bool.self, forKey: CodingKeys.specialRequirement)
        moreFrost = try container.decode(Bool.self, forKey: CodingKeys.moreFrost)
        moreSprinkle = try container.decode(Bool.self, forKey: CodingKeys.moreSprinkle)
        name = try container.decode(String.self, forKey: CodingKeys.name)
        city = try container.decode(String.self, forKey: CodingKeys.city)
        street = try container.decode(String.self, forKey: CodingKeys.street)
        zip = try container.decode(String.self, forKey: CodingKeys.zip)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cupcakeType, forKey: CodingKeys.cupcakeType)
        try container.encode(orderAmount, forKey: CodingKeys.orderAmount)
        try container.encode(specialRequirement, forKey: CodingKeys.specialRequirement)
        try container.encode(moreFrost, forKey: CodingKeys.moreFrost)
        try container.encode(moreSprinkle, forKey: CodingKeys.moreSprinkle)
        try container.encode(name, forKey: CodingKeys.name)
        try container.encode(city, forKey: CodingKeys.city)
        try container.encode(street, forKey: CodingKeys.street)
        try container.encode(zip, forKey: CodingKeys.zip)
    }
}
