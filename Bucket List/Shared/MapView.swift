//
//  MapView.swift
//  Bucket List
//
//  Created by bytedance on 2021/7/10.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var annotations = [MKPointAnnotation]()
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var selectedAnnotation: MKPointAnnotation?
    @Binding var showingAnnotationAlert: Bool
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = (annotation as! MKPointAnnotation).wrappedTitle + (annotation as! MKPointAnnotation).wrappedSubtitle
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView != nil {
                annotationView?.annotation = annotation
            } else {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            parent.selectedAnnotation = view.annotation as? MKPointAnnotation
            parent.showingAnnotationAlert = true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapUiView = MKMapView()
        mapUiView.delegate = context.coordinator
        mapUiView.addAnnotations(annotations)
        return mapUiView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if view.annotations.count != annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
    }
}
