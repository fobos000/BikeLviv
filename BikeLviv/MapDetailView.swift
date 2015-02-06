//
//  MapDetailView.swift
//  BikeLviv
//
//  Created by Ostap Horbach on 12/19/14.
//  Copyright (c) 2014 Ostap Horbach. All rights reserved.
//

import UIKit

class MapDetailView: UIView {

    var routeTappedFunction: (() -> ())?
    var numberOfSeats: Int
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    required init(coder aDecoder: NSCoder) {
        numberOfSeats = 0
        
        super.init(coder: aDecoder)
        
        var viewFromXib = NSBundle.mainBundle().loadNibNamed("PlaceDetailView", owner: self, options: nil).last as UIView
        self.addSubview(viewFromXib)
    }

    @IBAction func routeTapped(sender: AnyObject) {
        routeTappedFunction!();
    }
}
