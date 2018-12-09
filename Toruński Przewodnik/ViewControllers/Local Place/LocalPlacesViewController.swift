//
//  LocalPlacesViewController.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 31.07.2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Motion
import ChameleonFramework

class LocalPlacesViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {


    @IBOutlet weak var localARButtonView: LocalARView!
    @IBOutlet weak var mapKitView: MKMapView!
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    
    var myPlace: LocalPlace?
    var heading : Double! = 0.0
    var localPlace: Place?
    var position:CGPoint?
    
    var didSelectedAnnotation:Bool = false
    
    var placeAdded = false
    var distance : Float! = 0.0 {
        didSet {
            setStatusText()
        }
    }
    var status: String! {
        didSet {
            setStatusText()
        }
    }
    
    func setStatusText() {
        var text = "Status: \(status!)\n"
        text += "Distance: \(String(format: "%.2f m", distance))"
        print(text)
        //statusTextView.text = text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localARButtonView.layer.cornerRadius = 6.0
        localARButtonView.layer.borderWidth = 0
        localARButtonView.layer.borderColor = UIColor.flatWhite().withAlphaComponent(0.6).cgColor
        localARButtonView.layer.backgroundColor = UIColor.flatSkyBlueColorDark().withAlphaComponent(0.7).cgColor
        mapKitView.motionIdentifier = "viewOne"
        localARButtonView.motionIdentifier = "viewTwo"
        position = CGPoint(x: self.localARButtonView.frame.midX, y: self.localARButtonView.frame.midY)
        // Start location services
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapKitView.delegate = self
        // Set the initial status
        status = "Getting user location..."
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    

    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        performLocalSearch(region: mapKitView.region)
    }
    
    //MARK: - CLLocationManager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Implementing this method is required
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
            if(!placeAdded){
                let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region:MKCoordinateRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span)
                mapKitView.setRegion(region, animated: true)
            }
            
        }
    }
    
    
    func performLocalSearch(region: MKCoordinateRegion) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = myPlace?.getName()
        
        if(!placeAdded){
            request.region = region
        }
        else {
            request.region = mapKitView.region
        }
        
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            
            if error != nil {
                print("Error occurred in search:\(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")
                
                for item in response!.mapItems {
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = "Toruń"
                    self.mapKitView.addAnnotation(annotation)
                }
            }
        })
        placeAdded = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "localARSegue" {
            let vc = segue.destination as! LocalPlaceARViewController
            vc.myPlace = localPlace
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let coords = view.annotation?.coordinate
        let name = view.annotation?.title
        localPlace = Place(lat: (coords?.latitude)!, long: (coords?.longitude)!, name: (name! as String?)!, desc: "", cellImage: UIImage())
        if(!didSelectedAnnotation) {
            self.localARButtonView.frame = CGRect(x: 0, y: self.mapKitView.frame.maxY, width: self.localARButtonView.frame.width, height: self.localARButtonView.frame.height)
            self.localARButtonView.animate([.position(self.position!), .fadeIn, .duration(0.5)]) {
                self.localARButtonView.animate([.border(width: 3), .duration(0.3)])
                self.didSelectedAnnotation = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if(mapView.selectedAnnotations.count == 0) {
                self.localARButtonView.animate([.border(width: 0), .duration(0.3)]) {
                    self.localARButtonView.animate([.position(CGPoint(x: self.mapKitView.frame.midX, y: self.mapKitView.frame.maxY)), .fadeOut, .duration(0.5)])
                    self.didSelectedAnnotation = false
                }
            }
        }

    }
    
}
