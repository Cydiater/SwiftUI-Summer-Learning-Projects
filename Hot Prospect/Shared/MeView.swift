//
//  MeView.swift
//  Hot Prospect
//
//  Created by bytedance on 2021/7/13.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    @State private var name = ""
    @State private var email = ""
    
    var info: String {
        return "\(name)\n\(email)"
    }
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var body: some View {
        Form {
            TextField("name", text: $name)
                .textContentType(.name)
            TextField("email", text: $email)
                .textContentType(.emailAddress)
            
            Section {
                VStack(alignment: .center) {
                    Image(uiImage: generateQRCode(from: info))
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                    Text(info)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
