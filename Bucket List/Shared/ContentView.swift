//
//  ContentView.swift
//  Shared
//
//  Created by bytedance on 2021/7/10.
//

import SwiftUI
import MapKit
import LocalAuthentication

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            return title ?? "Unknown title"
        }
        set(newTitle) {
            title = newTitle
            objectWillChange.send()
        }
    }
    public var wrappedSubtitle: String {
        get {
            return subtitle ?? "Unknown subtitle"
        }
        set(newSubtitle) {
            subtitle = newSubtitle
            objectWillChange.send()
        }
    }
}

struct SimpleCircle: View {
    var body: some View {
        Circle()
            .foregroundColor(.blue)
            .frame(width: 20, height: 20)
            .opacity(0.5)
    }
}

struct SimpleCirclePlus: View {
    var body: some View {
        Image(systemName: "plus.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
            .foregroundColor(.black)
    }
}

struct ContentView: View {
    @State private var annotations = [CodableMKPointAnnotation]()
    @State private var centerCoordiate = CLLocationCoordinate2D()
    @State private var showingAnnotationAlert = false
    @State private var selectedAnnotation: MKPointAnnotation?
    @State private var showingEditView = false
    
    enum AuthenticateState {
        case locked, unlocked
    }
    
    @State private var authenticateState = AuthenticateState.locked
    
    func addAnnotation() {
        let annotation = CodableMKPointAnnotation()
        annotation.coordinate = centerCoordiate
        annotations.append(annotation)
        selectedAnnotation = annotation
        showingEditView = true
    }
    
    func authenticate() {
        let context = LAContext()
        let reason = "Unlock your annotations"
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: { success, error in
            if success {
                DispatchQueue.main.async {
                    authenticateState = .unlocked
                }
            } else {
                print(error?.localizedDescription ?? "Failed to authenticate")
            }
        })
    }
    
    var body: some View {
        if authenticateState == .locked {
            Button("Unlock") {
                authenticate()
            }
        } else {
            ZStack {
                MapView(annotations: annotations, centerCoordinate: $centerCoordiate, selectedAnnotation: $selectedAnnotation, showingAnnotationAlert: $showingAnnotationAlert)
                    .ignoresSafeArea()
                SimpleCircle()
                VStack {
                    Spacer()
                    Button(action: addAnnotation, label: {
                        SimpleCirclePlus()
                    })
                    .padding()
                }
            }
            .alert(isPresented: $showingAnnotationAlert, content: {
                Alert(title: Text(selectedAnnotation?.wrappedTitle ?? "Annotation not found!"), message: Text(selectedAnnotation?.wrappedSubtitle ?? "Annotation not found!"), primaryButton: .cancel(Text("OK")), secondaryButton: .default(Text("Edit"), action: {
                    self.showingEditView = true
                }))
            })
            .sheet(isPresented: $showingEditView, onDismiss: saveAnnotations, content: {
                EditView(annotation: selectedAnnotation!)
            })
            .onAppear(perform: restoreAnnotations)
        }
    }
    
    func restoreAnnotations() {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileUrl = url.appendingPathComponent("annotations.json")
        let decoder = JSONDecoder()
        guard let data = try? Data(contentsOf: fileUrl) else {
            print("restore failed")
            return
        }
        do {
            annotations = try decoder.decode([CodableMKPointAnnotation].self, from: data)
        } catch {
            print("restore failed")
        }
    }
    
    func saveAnnotations() {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileUrl = url.appendingPathComponent("annotations.json")
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(annotations) else {
            print("save failed")
            return
        }
        do {
            try data.write(to: fileUrl)
        } catch {
            print("save failed")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
