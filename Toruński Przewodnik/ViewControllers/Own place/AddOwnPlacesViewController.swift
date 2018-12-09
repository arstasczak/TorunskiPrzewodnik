//
//  AddOwnPlacesViewController.swift
//  
//
//  Created by Arkadiusz Stasczak on 21.10.2018.
//

import UIKit
import CoreData
import CoreLocation

class AddOwnPlacesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var ownPlaceImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UITextField!
    @IBOutlet weak var placeDescLabel: UITextField!
    
    var imageData: Data?
    var imagePicker = UIImagePickerController()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        ownPlaceImageView.isHidden = true
        requestForLocation()
    }
    
    func requestForLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func save() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "OwnPlace", in: managedContext) else {return}
        let ownPlace = NSManagedObject(entity: entity, insertInto: managedContext)
        
        let placeName = placeNameLabel.text
        let placeDesc = placeDescLabel.text
        
        let currentLatitude = locationManager.location?.coordinate.latitude
        let currentLongtitude = locationManager.location?.coordinate.longitude
        
        ownPlace.setValue(placeName, forKey: "placeName")
        ownPlace.setValue(placeDesc, forKey: "placeDescription")
        ownPlace.setValue(imageData, forKey: "placeImageData")
        ownPlace.setValue(currentLatitude, forKey: "latitude")
        ownPlace.setValue(currentLongtitude, forKey: "longtitude")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error)
        }
    }

    @IBAction func savePlace(_ sender: Any) {
        save()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let resizedImage = resizeImage(image: image, newWidth: 200)
        ownPlaceImageView.image = resizeImage(image: image, newWidth: 400)
        ownPlaceImageView.isHidden = false
        addImageButton.isHidden = true
        guard let data = resizedImage?.pngData() else {return}
        imageData = data
        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
