//
//  FacilityView.swift
//  SnowSeeker
//
//  Created by bytedance on 2021/7/22.
//

import SwiftUI



struct FacilityView: View {
    let name: String
    @State private var showingAlert = false
    
    var icon: Image {
        switch name {
        case "Family":
            return Image(systemName: "person.3.fill")
        case "Cross-country":
            return Image(systemName: "map.fill")
        case "Beginners":
            return Image(systemName: "sun.min.fill")
        case "Eco-friendly":
            return Image(systemName: "leaf.fill")
        case "Accommodation":
            return Image(systemName: "house.fill")
        default:
            return Image(systemName: "questionmark.circle")
        }
    }
    
    var message: String {
        switch name {
        case "Family":
            return "This resort is good for family travel."
        case "Cross-country":
            return "The route will cross several countries."
        case "Beginners":
            return "Suitable for beginners."
        case "Eco-friendly":
            return "We respect our mother earth."
        case "Accomodation":
            return "There will be hotels for resting."
        default:
            return "Unknown facility."
        }
    }
    
    var body: some View {
        VStack {
            icon
        }
        .onTapGesture(perform: {
            showingAlert.toggle()
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Facility Detail"), message: Text(message))
        })
    }
}

struct FacilityView_Previews: PreviewProvider {
    static var previews: some View {
        FacilityView(name: "Family")
    }
}
