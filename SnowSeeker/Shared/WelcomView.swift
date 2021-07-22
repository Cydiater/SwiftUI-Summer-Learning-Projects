//
//  WelcomView.swift
//  SnowSeeker
//
//  Created by bytedance on 2021/7/22.
//

import SwiftUI

struct WelcomView: View {
    var body: some View {
        VStack {
            Text("Welcom to SnowSeeker")
                .font(.largeTitle)
            Text("Slide over to show a list of resorts")
                .foregroundColor(.secondary)
        }
    }
}

struct WelcomView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomView()
    }
}
