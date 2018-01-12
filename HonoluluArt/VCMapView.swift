//
//  VCMapView.swift
//  HonoluluArt
//
//  Created by Philipp Jahn on 03.04.17.
//  Copyright © 2017 Philipp Jahn. All rights reserved.
//

import Foundation
import MapKit

extension ViewController: MKMapViewDelegate {
    
    // 1 - mapView(_:viewForAnnotation:) is the method that gets called for every annotation you add to the map (kind of like tableView(_:cellForRowAtIndexPath:) when working with table views), to return the view for each annotation.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { // also creating the little info button
        if let annotation = annotation as? Artwork {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                // 2 - Also similarly to tableView(_:cellForRowAtIndexPath:), map views are set up to reuse annotation views when some are no longer visible. So the code first checks to see if a reusable annotation view is available before creating a new one.
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3 - Here you use the plain vanilla MKAnnotationView class if an annotation view could not be dequeued. It uses the title and subtitle properties of your Artwork class to determine what to show in the callout – the little bubble that pops up when the user taps on the pin.
                
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                view.pinTintColor = annotation.pinColor()
            }
            return view
        }
        return nil
    }
    // When the user taps a map annotation pin, the callout shows an info button. If the user taps this info button, the mapView(_:annotationView:calloutAccessoryControlTapped:) method is called.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // In this method, you grab the Artwork object that this tap refers to and then launch the Maps app by creating an associated MKMapItem and calling openInMapsWithLaunchOptions on the map item.
        let location = view.annotation as! Artwork
        // Notice you’re passing a dictionary to this method. This allows you to specify a few different options; here the DirectionModeKeys is set to Driving. This will make the Maps app try to show driving directions from the user’s current location to this pin.
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
