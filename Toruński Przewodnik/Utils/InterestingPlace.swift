//
//  File.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 27.07.2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import Foundation
import UIKit

class Places {
    static let instance = Places()
    
    let places = [Place(lat: 53.01142, long: 18.61164, name: "Starówka", desc: "Najstarsza część Zespołu Staromiejskiego w Toruniu (pozostałe dwie to Nowe Miasto i zamek krzyżacki), ograniczona ulicami Fosa Staromiejska, pl. Teatralnym, ul. Podmurną i murami miejskimi od strony Wisły. Na Starym Mieście znajduje się większość najcenniejszych zabytków Torunia.", cellImage: UIImage(named: "starówka")!),
                  Place(lat: 53.0115, long: 18.6026, name: "Planetarium im. Władysława Dziewulskiego", desc: "Centrum popularyzacji kosmosu w Toruniu.",  cellImage: UIImage(named: "planetarium")!),
                  Place(lat: 53.0139, long: 18.6020, name: "CKK Jordanki", desc: "wielofunkcyjna sala koncertowo-kongresowa w Toruniu. Oficjalne otwarcie obiektu nastąpiło 12 grudnia 2015 roku. Centrum to jest siedzibą Toruńskiej Orkiestry Symfonicznej, a także głównej sceny Kujawsko-Pomorskiego Impresaryjnego Teatru Muzycznego.", cellImage: UIImage(named: "jordanki")!),
                  Place(lat: 53.0104, long: 18.6123, name: "Teatr Baj Pomorski", desc: "Teatr w swojej działalności koncentruje się przede wszystkim na sztukach przeznaczonych dla dzieci, wykorzystując nie tylko lalki, lecz także sztukę animacji, najnowsze techniki multimedialne i tradycyjną grę aktorską", cellImage: UIImage(named: "bajpomorski")!),
                  Place(lat: 53.0084, long: 18.6020, name: "Krzywa wieża w Toruniu", desc: "Jest to najciekawsza i najbardziej znana baszta toruńska. Poza tym stanowi najbardziej popularną budowlę architektoniczną Torunia i jedną z turystycznych atrakcji miasta, owianą licznymi legendami. Pochylona ku północy baszta z początku XIV wieku pochyliła się już najprawdopodobniej w tym samym stuleciu na skutek niestabilnego gruntu. Odchylenie od pionu wynosi 146 cm przy 15 m wysokości (od strony ulicy). Baszta stoi w linii murów miejskich i jako taka nie miała nigdy większego znaczenia obronnego Odgrywała rolę pomocniczej wieży strażniczej, jakich było w Toruniu wiele.",  cellImage: UIImage(named: "krzywawieza")!),
                  ]
    
    let localPlaces = [LocalPlace(name: "Restauracja", cellImage: UIImage()),
                       LocalPlace(name: "Hotel", cellImage: UIImage()),
                       LocalPlace(name: "Kawiarnia", cellImage: UIImage()),
                       ]
}

class Place {
    private var latitude: Double
    private var longtitude: Double
    private var name: String
    private var description: String
    private var cellImage: UIImage
    
    init(lat: Double, long: Double, name: String, desc: String, cellImage: UIImage) {
        self.description = desc
        self.latitude = lat
        self.longtitude = long
        self.name = name
        self.cellImage = cellImage
    }
    
    public func getName() -> String{
        return self.name
    }
    
    public func getDesc() -> String{
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
    
    init(name: String,cellImage: UIImage) {
        self.name = name
        self.cellImage = cellImage
    }
    
    public func getName() -> String{
        return self.name
    }
    
    public func getCellImage() -> UIImage {
        return self.cellImage
    }

}
