//
//  ViewControllerSecondScreen.swift
//  Should I Ride?
//
//  Created by Andy Seavers on 12/21/15.
//  Copyright © 2015 Andy Seavers. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MapKit



class ViewControllerSecondScreen: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var yesOrNoLabel: UILabel!
    var data: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yesOrNoLabel.text = data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }
    

    

}
