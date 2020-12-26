//
//  MapViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 26.12.2020.
//

import UIKit
import MapKit

class MapViewController: UIViewController , MKMapViewDelegate, UIGestureRecognizerDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let gestureZ = UILongPressGestureRecognizer(target: self, action: #selector(self.revealRegionDetailsWithLongPressOnMap(sender:)))
        view.addGestureRecognizer(gestureZ)
    }
    
    @IBAction func revealRegionDetailsWithLongPressOnMap(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.began { return }
        let touchLocation = sender.location(in: mapView)
        
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        mapView.addAnnotation(annotation)
        print("Tapped at lat: \(locationCoordinate) long: \(locationCoordinate.longitude)")
    }
}
