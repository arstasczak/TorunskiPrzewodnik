//
//  PlaceCell.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 30.07.2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {

    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var placeDescriptionTextView: UITextView!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(place: Place) {
        self.placeDescriptionTextView.text = place.getDesc()
        self.placeImageView.image = place.getCellImage()
        self.placeNameLabel.text = place.getName()
    }

}

class LocalPlaceCell: UITableViewCell {
    
    @IBOutlet weak var localPlaceImageView: UIImageView!
    @IBOutlet weak var localPlaceNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateCell(place: LocalPlace) {
        self.localPlaceImageView.image = place.getCellImage()
        self.localPlaceNameLabel.text = place.getName()
    }
    
}
