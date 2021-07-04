//
//  AstronuatView.swift
//  Moonshot
//
//  Created by bytedance on 2021/6/29.
//

import SwiftUI

struct AstronuatView: View {
    let astronuat: Astronaut
    
    var body: some View {
        ScrollView {
            Image(astronuat.id)
                .resizable()
                .scaledToFit()
                .frame(width: .infinity)
            Text(astronuat.description)
        }
        .padding()
    }
}

struct AstronuatView_Previews: PreviewProvider {
    static let astronuats: [Astronaut] = Bundle.main.decode("astronuats.json")
    
    static var previews: some View {
        AstronuatView(astronuat: astronuats[0])
    }
}
