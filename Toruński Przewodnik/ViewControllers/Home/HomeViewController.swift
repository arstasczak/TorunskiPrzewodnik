//
//  HomeViewController.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 27.07.2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var interestingPlacesButton: UIButton!
    @IBOutlet weak var localPlacesButton: UIButton!
    @IBOutlet weak var ownPlacesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
    }
    
    func addTargets() {
        self.historyButton.addTarget(self, action: #selector(showHistoryView), for: .touchUpInside)
        self.interestingPlacesButton.addTarget(self, action: #selector(showInterestingPlaces), for: .touchUpInside)
        self.localPlacesButton.addTarget(self, action: #selector(showLocalPlaces), for: .touchUpInside)
        self.ownPlacesButton.addTarget(self, action: #selector(showOwnPlaces), for: .touchUpInside)
    }
    
    @objc func showLocalPlaces() {
        self.makeSegue(to: .localPlaceChoose, in: .localPlace)
    }
    
    @objc func showInterestingPlaces() {
        self.makeSegue(to: .interestingPlaceChoose, in: .interestingPlace)
    }
    
    @objc func showOwnPlaces() {
        self.makeSegue(to: .ownPlaceChoose, in: .ownPlace)
    }
    
    @objc func showHistoryView() {
        self.makeSegue(to: .imageScan, in: .imageScan)
    }
    
    func makeSegue(to destination: segueDestination, in storyboard: storyboardName) {
        let storyboard = UIStoryboard(name: storyboard.identifier(), bundle: Bundle.main)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: destination.identifier())
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }

}
