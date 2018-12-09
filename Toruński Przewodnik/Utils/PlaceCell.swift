//
//  PlaceCell.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 30.07.2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import UIKit
import CoreData

class PlaceCell: UITableViewCell {

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeDescLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateCell(place: Place) {
        self.placeDescLabel.text = place.getDesc()
        self.placeImageView.image = place.getCellImage()
        self.placeNameLabel.text = place.getName()
    }

}

class LocalPlaceCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var localPlaceImageView: UIImageView!
    @IBOutlet weak var localPlaceNameLabel: UILabel!
    @IBOutlet weak var localPlaceDescLabel: UILabel!
    
    
    
    func updateCell(place: LocalPlace) {
        self.localPlaceImageView.image = place.getCellImage()
        self.localPlaceNameLabel.text = place.getName()
        self.localPlaceDescLabel.text = place.getDesc()

    }
    
    func updateCell(place: Place) {
        self.localPlaceImageView.image = place.getCellImage()
        self.localPlaceNameLabel.text = place.getName()
        self.localPlaceDescLabel.text = place.getDesc()
        self.localPlaceImageView.layer.cornerRadius = 6
        self.localPlaceImageView.layer.masksToBounds = true
    }
    
    func updateCellWithCoreData(place: NSManagedObject) {
      /*  if let imageData: NSData = (place.value(forKey: "placeImage") as? NSData){
            self.localPlaceImageView.image = UIImage(data: imageData as Data, scale: 0.1)
        }*/
        self.localPlaceNameLabel.text = place.value(forKey: "placeName") as? String
        self.localPlaceDescLabel.text = place.value(forKey: "placeDescription") as? String
    }
    
}
