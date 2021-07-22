//
//  ResortView.swift
//  SnowSeeker
//
//  Created by bytedance on 2021/7/22.
//

import SwiftUI

struct PriceAndSizeView: View {
    let resort: Resort
    
    var body: some View {
        HStack {
            Spacer()
            Text("Price: \(resort.price) USD")
            Spacer()
            Text("Size: \(resort.size) Hectare")
            Spacer()
        }
        .font(.caption)
    }
}

struct SnowDepthAndElevationView: View {
    let resort: Resort
    
    var body: some View {
        HStack {
            Spacer()
            Text("Snow Depth: \(resort.snowDepth) Meter")
            Spacer()
            Text("Elevation: \(resort.elevation) Meter")
            Spacer()
        }
        .font(.caption)
    }
}

struct ResortView: View {
    let resort: Resort
    @EnvironmentObject var likeMap: LikeMap
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var isLike: Bool {
        get {
            return likeMap.get(id: resort.id)
        }
        set(newValue) {
            likeMap.set(id: resort.id, withValue: newValue)
        }
    }
    
    var body: some View {
        ScrollView {
            Image(resort.id)
                .resizable()
                .scaledToFit()
            if sizeClass == .compact {
                VStack {
                    PriceAndSizeView(resort: resort)
                    SnowDepthAndElevationView(resort: resort)
                }
            } else {
                HStack {
                    PriceAndSizeView(resort: resort)
                    SnowDepthAndElevationView(resort: resort)
                }
            }
            Text(resort.description)
                .padding()
            HStack {
                ForEach(resort.facilities, id: \.self) { name in
                    FacilityView(name: name)
                }
            }
            .padding()
        }
        .navigationTitle(resort.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            likeMap.set(id: resort.id, withValue: !isLike)
        }) {
            Image(systemName: isLike ? "heart.fill" : "heart")
                .foregroundColor(.red)
        })
    }
}

struct ResortView_Previews: PreviewProvider {
    static let resorts: [Resort] = Bundle.main.loadJSON(from: "resorts.json")
    
    static var previews: some View {
        ResortView(resort: resorts[0])
            .environmentObject(LikeMap())
    }
}
