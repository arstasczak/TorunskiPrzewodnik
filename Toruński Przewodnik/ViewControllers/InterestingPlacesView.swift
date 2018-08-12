//
//  InterestingPlacesView.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 27.07.2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import UIKit
import ARKit
import CoreLocation
import ARCL
import MapKit

class InterestingPlacesView: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {


    @IBOutlet var pinView: BubbleView!
    @IBOutlet weak var mapKitView: MKMapView!
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    var modelNode = SCNNode()
    var sceneLocationView = SceneLocationView()
    let configuration = ARWorldTrackingConfiguration()
    
    var myPlace: Place?
    var heading : Double! = 0.0
    
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
        //statusTextView.text = text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
  
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
        
        sceneLocationView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-170)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        
        // Run the view's session
        sceneLocationView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneLocationView.pause()
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
            if(!placeAdded) {
                addPlace()
            }
           
        }
    }
    
    
    func addPlace() {
        let coordinate = CLLocationCoordinate2D(latitude: (myPlace?.getLat())!, longitude: (myPlace?.getLong())!)
        let location = CLLocation(coordinate: coordinate, altitude: 300)
        

        let distanceBetween = location.distance(from: userLocation)/1000
        pinView.distanceLabel.text = String(format:"%.1f", distanceBetween)+" km"
        
        
        let name: String = (myPlace?.getName())!
        pinView.nameLabel.text = name
        
        let pinImage = UIImage(view: pinView!)
        
        let annotationNode = LocationAnnotationNode(location: location, image: pinImage)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapKitView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = myPlace?.getName()
        annotation.subtitle = "Toruń"
        mapKitView.addAnnotation(annotation)
        placeAdded = true
        addRoute(sourceLocation: userLocation.coordinate, destinationLocation: location.coordinate)
    }
    
    func addRoute(sourceLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapKitView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            for step in route.steps {
                print(step.instructions)
            }
            let rect = route.polyline.boundingMapRect
            self.mapKitView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue.withAlphaComponent(0.6)
        renderer.lineWidth = 5.0
        return renderer
    }
}


