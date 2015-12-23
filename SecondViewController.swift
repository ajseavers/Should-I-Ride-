//
//  SecondViewController.swift
//  Should I Ride?
//
//  Created by Andy Seavers on 12/22/15.
//  Copyright © 2015 Andy Seavers. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
        @IBOutlet weak var yesOrNoLabel: UILabel!
        var data: String! = "No"
        
    @IBOutlet weak var startOverButton: UIButton!
        
    override func viewDidLoad() {
            super.viewDidLoad()
            
            yesOrNoLabel.text = data
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
