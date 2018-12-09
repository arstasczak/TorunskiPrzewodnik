//
//  Helper.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 19.10.2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import Foundation

enum rowSelected: Int {
    case interestingPlace = 0
    case localPlace = 1
    case imageScan = 2
    case ownPlace = 3
    
    func rowID() -> Int {
        return self.rawValue
    }
}

enum segueDestination: String {
    case mainView = "mainView"
    case imageScan = "imageScan"
    case interestingPlaceChoose = "interestingPlaceChoose"
    case interestingPlaceAR = "interestingPlaceAR"
    case localPlaceChoose = "localPlaceChoose"
    case localPlaceMap = "localPlaceMap"
    case localPlaceAR = "localPlaceAR"
    case ownPlaceChoose = "ownPlaceChoose"
    case ownPlaceAdd = "ownPlaceAdd"
    case webView = "webView"
    
    func identifier() -> String{
        return self.rawValue
    }
}

enum storyboardName: String {
    case main = "Main"
    case imageScan = "ImageScan"
    case interestingPlace = "InterestingPlaces"
    case localPlace = "LocalPlaces"
    case ownPlace = "OwnPlaces"
    
    func identifier() -> String{
        return self.rawValue
    }
}
