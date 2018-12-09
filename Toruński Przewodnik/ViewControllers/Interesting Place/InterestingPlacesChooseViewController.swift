//
//  InterestingPlacesChooseViewController.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 20.08.2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import UIKit
import FirebaseDatabase
import JGProgressHUD

class InterestingPlacesChooseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    
    let ref = Database.database().reference(withPath: "places")
    
    var places = [Place]()
    var expandedCells = [Int]()
    let progressHud = JGProgressHUD()
    var overlayView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        overlayView = UIView(frame: view.frame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(overlayView)
        progressHud.show(in: overlayView)
        ref.observe(.value, with: { snapshot in
            var newPlaces = [Place]()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let place = Place(snapshot: snapshot) {
                    newPlaces.append(place)
                }
            }
            self.places = newPlaces
            self.tableView.reloadData()
            self.progressHud.dismiss()
            DispatchQueue.main.async {
                self.overlayView.removeFromSuperview()
            }
        })
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 + heightForView(text: places[indexPath.row].getDesc(), font: UIFont.systemFont(ofSize: 13), width: 375)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceCell
        cell.updateCell(place: places[indexPath.row])
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placeSegue" {
            let vc = segue.destination as! InterestingPlacesView
            let cell = sender as! PlaceCell
            let indexPaths = self.tableView.indexPath(for: cell)
            vc.myPlace = places[(indexPaths?.row)!]
        }
        
    }
    
}
