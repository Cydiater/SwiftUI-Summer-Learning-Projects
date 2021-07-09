//
//  ContentView.swift
//  Shared
//
//  Created by bytedance on 2021/7/8.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var radiusAmount: Double = 20
    @State private var intensityAmount: Double = 0.5
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var proceedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var currentFilter: CIFilter = CIFilter.crystallize()
    @State private var showingSwitchFilterActionSheet = false
    
    let context = CIContext()
    
    func applyFilter() {
        let keys = currentFilter.inputKeys
        if keys.contains("inputRadius") {
            currentFilter.setValue(radiusAmount, forKey: kCIInputRadiusKey)
        }
        if keys.contains("inputIntensity") {
            currentFilter.setValue(intensityAmount, forKey: kCIInputIntensityKey)
        }
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            proceedImage = UIImage(cgImage: cgImage)
            image = Image(uiImage: proceedImage!)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyFilter()
    }
    
    var body: some View {
        let radius = Binding<Double>(
            get: {
                return radiusAmount
            },
            set: { newValue in
                radiusAmount = newValue
                applyFilter()
            }
        )
        let intensity = Binding<Double>(
            get: {
                return intensityAmount
            },
            set: { newValue in
                intensityAmount = newValue
                applyFilter()
            }
        )
        
        return NavigationView {
            VStack {
                ZStack {
                    Color.gray
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Button("Select a photo from album") {
                            showingImagePicker.toggle()
                        }
                        .foregroundColor(.white)
                        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                            ImagePickerView(image: $inputImage)
                        }
                    }
                }
                if currentFilter.inputKeys.contains("inputRadius") {
                    HStack {
                        Text("Radius")
                        Slider(value: radius, in: 1...100)
                            .disabled(image == nil)
                    }
                }
                if currentFilter.inputKeys.contains("inputIntensity") {
                    HStack {
                        Text("Intensity")
                        Slider(value: intensity, in: 0...1.0)
                            .disabled(image == nil)
                    }
                }
                HStack {
                    Button("Switch filter") {
                        showingSwitchFilterActionSheet.toggle()
                    }
                    .actionSheet(isPresented: $showingSwitchFilterActionSheet, content: {
                        ActionSheet(title: Text("Switch Filter"), message: Text("Choose your filter"), buttons: [.default(Text("Crystallize"), action: {
                            currentFilter = CIFilter.crystallize()
                            loadImage()
                        }),
                        .default(Text("Sepia"), action: {
                            currentFilter = CIFilter.sepiaTone()
                            loadImage()
                        })
                        ,
                        .cancel()])
                    })
                    Spacer()
                    Button("Save") {
                        guard let proceedImage = proceedImage else { return }
                        let imageSaver = ImageSaver()
                        imageSaver.writeToPhotoAlbum(image: proceedImage)
                    }
                }
            }
            .padding()
            .navigationTitle("Instafilter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
