//
//  PlacesPickController.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 30.07.2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import UIKit

class PlacesPickController: UITableViewController {
    
    let places = Places.instance.places
    var expandedCells = [Int]()
    var selectedRow: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceCell
        cell.updateCell(place: places[indexPath.row])
        cell.infoButton.tag = indexPath.row
        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placeSegue" {
            let vc = segue.destination as! InterestingPlacesView
            guard let index = tableView.indexPathForSelectedRow?.row else {return}
            vc.myPlace = places[index]
        }
        
    }
    
    
    @IBAction func expandCell(_ sender: AnyObject) {
        if expandedCells.contains(sender.tag) {
            expandedCells = expandedCells.filter({ $0 != sender.tag})
        }
        else {
            expandedCells.append(sender.tag)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if expandedCells.contains(indexPath.row){
            return 285
        }
        else{
            return 105
        }
    }
}
