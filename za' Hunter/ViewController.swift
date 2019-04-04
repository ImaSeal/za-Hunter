//
//  ViewController.swift
//  za' Hunter
//
//  Created by David Levit on 4/3/19.
//  Copyright © 2019 John Hersey High School. All rights reserved.
//

import UIKit
import MapKit
import SafariServices
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var pizzaJoints: [MKMapItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isEqual(mapView.userLocation) {
            return nil
        }
        let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.image = UIImage(named: "Pizza Image")
        pin.canShowCallout = true
        let button = UIButton(type: .detailDisclosure)
        pin.rightCalloutAccessoryView = button
        return pin
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        var currentMapItem = MKMapItem()
        if let title = view.annotation?.title, let pizzaName = title {
            for mapItem in pizzaJoints {
                if mapItem.name == pizzaName {
                    currentMapItem = mapItem
                }
            }
        }
        let placemark = currentMapItem.placemark
        print(placemark)
        if let url = currentMapItem.url {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Pizza"
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        request.region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                return
            }
            for mapItem in response.mapItems {
                self.pizzaJoints.append(mapItem)
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
            }
            
        }
    }
    @IBAction func zoomButtonPressed(_ sender: Any) {
        
        let center = currentLocation.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
}
    





