//
//  File.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 27.07.2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift
import FirebaseDatabase

class Places {
    static let instance = Places()
    
    let places = [Place]()
    
    let localPlaces = [LocalPlace(name: "Restauracje", cellImage: UIImage.fontAwesomeIcon(name: .glass, textColor: UIColor.flatSkyBlueColorDark(), size: CGSize(width: 100, height: 100)), desc: "Lokalne restauracje"),
                       LocalPlace(name: "Hotele", cellImage: UIImage.fontAwesomeIcon(name: .hotel, textColor: UIColor.flatSkyBlueColorDark(), size: CGSize(width: 100, height: 100)), desc: "Noclegi w Toruniu"),
                       LocalPlace(name: "Kawiarnia", cellImage: UIImage.fontAwesomeIcon(name: .coffee, textColor: UIColor.flatSkyBlueColorDark(), size: CGSize(width: 100, height: 100)), desc: "Najlepsze kawy i słodkości"),
                       LocalPlace(name: "Muzea", cellImage: UIImage.fontAwesomeIcon(name: .building, textColor: UIColor.flatSkyBlueColorDark(), size: CGSize(width: 100, height: 100)), desc: "Wystawy i eksponaty"),
                       LocalPlace(name: "Galerie sztuki", cellImage: UIImage.fontAwesomeIcon(name: .image, textColor: UIColor.flatSkyBlueColorDark(), size: CGSize(width: 100, height: 100)), desc: "Artystyczne wystawy"),
                       LocalPlace(name: "Galerie handlowe", cellImage: UIImage.fontAwesomeIcon(name: .shoppingBag, textColor: UIColor.flatSkyBlueColorDark(), size: CGSize(width: 100, height: 100)), desc: "Zakupy oraz rozrywka"),
                       ]
}

class Place{
    private var latitude: Double = 0
    private var longtitude: Double = 0
    private var name: String = ""
    private var description: String = ""
    private var cellImage: UIImage = UIImage()
    
    init(lat: Double, long: Double, name: String, desc: String, cellImage: UIImage) {
        self.description = desc
        self.latitude = lat
        self.longtitude = long
        self.name = name
        self.cellImage = cellImage
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let description = value["description"] as? String,
            let latitude = value["latitude"] as? Double,
            let longtitude = value["longtitude"] as? Double else {
                return
        }
        
        self.name = name
        self.description = description
        self.latitude = latitude
        self.longtitude = longtitude
        self.cellImage = UIImage.fontAwesomeIcon(name: .map, textColor: UIColor.flatSkyBlueColorDark(), size: CGSize(width: 75, height: 75))
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func getDesc() -> String {
        return self.description
    }
    
    public func getLat() -> Double {
        return self.latitude
    }
    
    public func getLong() -> Double {
        return self.longtitude
    }
    
    public func getCellImage() -> UIImage {
        return self.cellImage
    }
}

class LocalPlace {

    private var name: String
    private var cellImage: UIImage
    private var description: String
    
    init(name: String,cellImage: UIImage, desc: String) {
        self.name = name
        self.cellImage = cellImage
        self.description = desc
    }
    
    public func getName() -> String{
        return self.name
    }
    
    public func getCellImage() -> UIImage {
        return self.cellImage
    }
    
    public func getDesc() -> String {
    return self.description
    }

}
