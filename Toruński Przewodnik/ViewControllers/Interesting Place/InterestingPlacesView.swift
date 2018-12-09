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


    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
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
    
      let openGMButton = UIButton()
    
    override func viewDidLoad() {
        
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        view.bringSubviewToFront(mapKitView);
        
        let arTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleARViewTouch))
        sceneLocationView.addGestureRecognizer(arTapGesture)
  
        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapViewTouch))
        mapKitView.addGestureRecognizer(mapTapGesture)
        
        // Start location services
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapKitView.delegate = self
        // Set the initial status
        status = "Getting user location..."
        
        mapKitView.addSubview(openGMButton)
        
        openGMButton.layer.backgroundColor = UIColor.white.cgColor
        openGMButton.layer.masksToBounds = true
        openGMButton.layer.cornerRadius = 5
        openGMButton.setImage(UIImage.fontAwesomeIcon(name: .mapO, textColor: UIColor.black.withAlphaComponent(0.8), size: CGSize(width: 25, height: 25)), for: .normal)
        
        // Set open maps button constraints
        openGMButton.translatesAutoresizingMaskIntoConstraints = false
        openGMButton.trailingAnchor.constraint(equalTo: mapKitView.trailingAnchor, constant: -15).isActive = true
        openGMButton.topAnchor.constraint(equalTo: mapKitView.topAnchor, constant: 15).isActive = true
        openGMButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        openGMButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        openGMButton.addTarget(self, action: #selector(openGoogleMaps), for: .touchUpInside)
        
    }
    
    @objc func openGoogleMaps() {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            guard let latitude = myPlace?.getLat(), let longitude = myPlace?.getLong() else {
                return
            }
            UIApplication.shared.open(NSURL(string: "comgooglemaps://?saddr=&daddr=\(Float(latitude)),\(Float(longitude))&directionsmode=driving")! as URL, options: [:])
        } else
        {
            NSLog("Can't use com.google.maps://");
        }
    }
    
    @objc func handleARViewTouch() {
        mapHeightConstraint.constant = 175
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleMapViewTouch() {
        mapHeightConstraint.constant = 350
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.translatesAutoresizingMaskIntoConstraints = false
        sceneLocationView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sceneLocationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sceneLocationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sceneLocationView.heightAnchor.constraint(equalToConstant: view.bounds.height - 175).isActive = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneLocationView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneLocationView.pause()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
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
        let location = CLLocation(coordinate: coordinate, altitude: 50)

        let distanceBetween = location.distance(from: userLocation)/1000
        pinView.distanceLabel.text = String(format:"%.1f", distanceBetween)+" km"
        
        let name: String = (myPlace?.getName())!
        pinView.nameLabel.text = name
        
        let pinImage = UIImage(view: pinView!)
        
        let annotationNode = LocationAnnotationNode(location: location, image: pinImage)
        
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
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
        
        let directionRequest = MKDirections.Request()
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
            self.mapKitView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            for step in route.steps {
                print(step.instructions)
            }
            let rect = route.polyline.boundingMapRect
            let boundingRect = MKMapRect(origin: route.polyline.boundingMapRect.origin, size: MKMapSize(width: rect.size.width+10, height: rect.size.height+10))
            self.mapKitView.setRegion(MKCoordinateRegion(boundingRect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.flatBlue().withAlphaComponent(0.4)
        renderer.lineWidth = 5.0
        return renderer
    }
}


