//
//  AddOwnPlaceViewController.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 21.10.2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import UIKit
import Foundation

class AddOwnPlaceViewController: UIViewController {

    @IBOutlet weak var ownPlaceName: UITextField!
    @IBOutlet weak var ownPlaceDescription: UITextField!
    @IBOutlet weak var ownPlacePhoto: UIImageView!
    @IBOutlet weak var ownPlaceAddButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createContext()
    }
    
    
    func createContext() {
        let appDelegate = UI
        let context = appDelegate.shared
    }
}
