//
//  MissionView.swift
//  Moonshot
//
//  Created by bytedance on 2021/6/29.
//

import SwiftUI

struct MissionView: View {
    let mission: Mission
    var crews: [Astronaut]
    
    var body: some View {
        ScrollView {
            Image(mission.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: .infinity)
                .padding()
            
            List(crews) { crew in
                NavigationLink(destination: AstronuatView(astronuat: crew)) {
                    HStack {
                        Image(crew.id)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Ellipse())
                            .frame(width: 44, height: 44)
                        
                        VStack(alignment: .leading) {
                            Text(crew.name)
                                .font(.headline)
                        }
                    }
                }
            }
            
            Text(mission.description)
                .padding()
                .layoutPriority(1)
        }
    }
    
    init(mission: Mission, astronuats: [Astronaut]) {
        self.mission = mission
        self.crews = [Astronaut]()
        for crew in mission.crew {
            if let astronuat = astronuats.first(where: { $0.id == crew.name }) {
                self.crews.append(astronuat)
            }
        }
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronuats: [Astronaut] = Bundle.main.decode("astronuats.json")
    
    static var previews: some View {
        MissionView(mission: missions[0], astronuats: astronuats)
    }
}
