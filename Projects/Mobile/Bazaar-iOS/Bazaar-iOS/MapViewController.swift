//
//  MapViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 26.12.2020.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate {
    func mapViewControllerDidGetLocation(latitude:Float,longitude:Float,annotation:MKPointAnnotation)
    func mapViewControllerDidFail()
}

class MapViewController: UIViewController , MKMapViewDelegate, UIGestureRecognizerDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!
    var annotations: [MKPointAnnotation] = []
    var latitude:Float? = nil
    var longitude:Float? = nil
    var delegate:MapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let gestureZ = UILongPressGestureRecognizer(target: self, action: #selector(self.revealRegionDetailsWithLongPressOnMap(sender:)))
        view.addGestureRecognizer(gestureZ)
    }
    override func viewWillAppear(_ animated: Bool) {
        if annotations.count != 0{
            mapView.addAnnotation(annotations[0])
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let lat = self.latitude, let lng = self.longitude {
            self.delegate?.mapViewControllerDidGetLocation(latitude: lat, longitude: lng, annotation: annotations[annotations.count-1])
        }else {
            self.delegate?.mapViewControllerDidFail()
        }
    }
    
    @IBAction func revealRegionDetailsWithLongPressOnMap(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.began { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotations.forEach { (annotation) in
            mapView.removeAnnotation(annotation)
        }
        mapView.addAnnotation(annotation)
        annotations.append(annotation)
        self.latitude = Float(locationCoordinate.latitude)
        self.longitude = Float(locationCoordinate.longitude)
    }
    
    @IBAction func saveGoBackButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
