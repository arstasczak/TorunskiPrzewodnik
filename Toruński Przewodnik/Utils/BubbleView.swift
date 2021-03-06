//
//  BubbleView.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 30.07.2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import UIKit

class BubbleView: UIView {

    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!

}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        image!.draw(in: CGRect(x: 0, y: 0, width: 200, height: 200))
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}

class LocalARView: UIView {
    @IBOutlet weak var checkARButton: UIButton!
}
