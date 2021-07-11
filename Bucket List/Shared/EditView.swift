//
//  EditView.swift
//  Bucket List
//
//  Created by bytedance on 2021/7/11.
//

import SwiftUI
import MapKit

struct Results: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    static func < (lhs: Page, rhs: Page) -> Bool {
        return lhs.title < rhs.title
    }
    
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
}

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var annotation: MKPointAnnotation
    @State private var nearbyAnnotations = [MKPointAnnotation]()
    enum fetchingState {
        case loading, finished, failed
    }
    @State private var fetching = fetchingState.loading
    
    func loadNearbyData() {
        guard let url = URL(string: "https://en.wikipedia.org/w/api.php?ggscoord=\(annotation.coordinate.latitude)%7C\(annotation.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json") else {
            print("Invalid url format")
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                fetching = .failed
                print("network error")
                return
            }
            let decoder = JSONDecoder()
            guard let results = try? decoder.decode(Results.self, from: data) else {
                fetching = .failed
                print("decode error")
                return
            }
            for page in results.query.pages.values.sorted() {
                let annotation = MKPointAnnotation()
                annotation.wrappedTitle = page.title
                annotation.wrappedSubtitle = page.terms?["description"]?[0] ?? "No further infomation"
                nearbyAnnotations.append(annotation)
            }
            fetching = .finished
        }
        task.resume()
    }
    
    var body: some View {
        if annotation.title == nil {
            annotation.title = annotation.wrappedTitle
        }
        if annotation.subtitle == nil {
            annotation.subtitle = annotation.wrappedSubtitle
        }
        
        return NavigationView {
            Form {
                TextField("Title", text: $annotation.wrappedTitle)
                TextField("Description", text: $annotation.wrappedSubtitle)
                
                Section(header: Text("Nearby")) {
                    if fetching == .finished {
                        List(nearbyAnnotations, id: \.self) { nearby in
                            Button(action: {
                                annotation.wrappedTitle = nearby.wrappedTitle
                                annotation.wrappedSubtitle = nearby.wrappedSubtitle
                            }) {
                                VStack(alignment: .leading) {
                                    Text(nearby.wrappedTitle).font(.headline)
                                    Text(nearby.wrappedSubtitle).font(.subheadline)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    } else if fetching == .loading {
                        Text("Loading...")
                    } else if fetching == .failed {
                        Text("Failed.")
                    }
                }
            }
            .navigationTitle("Edit Annotation")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Save") {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear(perform: loadNearbyData)
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(annotation: MKPointAnnotation.examples[0])
    }
}

extension MKPointAnnotation {
    static var examples: [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        let coordinates = [
            CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074),
            CLLocationCoordinate2D(latitude: 31.2304, longitude: 121.4737),
            CLLocationCoordinate2D(latitude: 22.3193, longitude: 114.1694)
        ]
        for coordinate in coordinates {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotations.append(annotation)
        }
        return annotations
    }
}
