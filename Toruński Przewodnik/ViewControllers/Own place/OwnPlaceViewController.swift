//
//  OwnPlaceViewController.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 19.10.2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import UIKit
import CoreData

class OwnPlaceViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var ownPlacesCoreData:[NSManagedObject] = []
    var ownPlaces: [Place] = []
    @IBOutlet weak var ownPlacesCollectionView: UICollectionView!
    
    @IBOutlet weak var myPlacesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myPlacesCollectionView.delegate = self
        myPlacesCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ownPlaces.removeAll()
        getData()
        myPlacesCollectionView.reloadData()  
    }
    
    func getData(){
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "OwnPlace")
            
            do {
                self.ownPlacesCoreData = try context.fetch(fetchRequest)
            }
            catch let error as NSError {
                print(error)
            }
        
        for place in ownPlacesCoreData {
            guard let latitude = place.value(forKey: "latitude") as? Double,
                let longtitude = place.value(forKey: "longtitude") as? Double,
                let placeName = place.value(forKey: "placeName") as? String,
                let placeDesc = place.value(forKey: "placeDescription") as? String,
                let imageData = place.value(forKey: "placeImageData") as? Data
                else {return}
            
            if let image = UIImage(data: imageData as Data){
                ownPlaces.append(Place(lat: latitude, long: longtitude, name: placeName, desc: placeDesc, cellImage: image))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ownPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ownPlacesCollectionView.dequeueReusableCell(withReuseIdentifier: "ownPlaceCell", for: indexPath) as! LocalPlaceCell
        cell.updateCell(place: ownPlaces[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "LocalPlaces", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "localPlaceAR") as? LocalPlaceARViewController else {return}
        
        vc.myPlace = ownPlaces[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
