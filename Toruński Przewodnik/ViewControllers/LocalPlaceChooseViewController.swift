//
//  LocalPlaceChooseViewController.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 31.07.2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import UIKit

class LocalPlaceChooseViewController: UITableViewController {


    let places = Places.instance.localPlaces
    var expandedCells = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "localPlaceCell", for: indexPath) as! LocalPlaceCell
        cell.updateCell(place: places[indexPath.row])
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "localPlaceSegue" {
            let vc = segue.destination as! LocalPlacesViewController
            guard let index = tableView.indexPathForSelectedRow?.row else {return}
            vc.myPlace = places[index]
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }

}
