//
//  LocalPlaceChooseViewController.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 31.07.2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import UIKit

class LocalPlaceChooseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var localPlaceCollectionView: UICollectionView!
    
    let places = Places.instance.localPlaces
    var expandedCells = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localPlaceCollectionView.delegate = self
        localPlaceCollectionView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "localPlaceSegue" {
            let vc = segue.destination as! LocalPlacesViewController
            let cell = sender as! LocalPlaceCell
            let indexPaths = self.localPlaceCollectionView.indexPath(for: cell)
            vc.myPlace = places[(indexPaths?.row)!]
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = localPlaceCollectionView.dequeueReusableCell(withReuseIdentifier: "localCell", for: indexPath) as! LocalPlaceCell
        cell.updateCell(place: places[indexPath.row])
        return cell
    }

}
