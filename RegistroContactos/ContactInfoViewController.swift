//
//  ContactInfoViewController.swift
//  RegistroContactos
//
//  Created by Jorge Rebollo J on 12/09/16.
//  Copyright © 2016 RGStudio. All rights reserved.
//

import UIKit
import CoreData

class ContactInfoViewController: UIViewController {
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactPhoneLabel: UILabel!
    @IBOutlet weak var contactCivilStatusLabel: UILabel!
    @IBOutlet weak var contactSexLabel: UILabel!
    @IBOutlet weak var contactPersonalInterestLabel: UILabel!
    
    var contact = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.tintColor = UIColor.whiteColor();
    }
    
    override func viewWillAppear(animated: Bool) {
        contactNameLabel.text = contact["name"] as? String
        contactPhoneLabel.text = contact["telephone"] as? String
        contactCivilStatusLabel.text = contact["civilStatus"] as? String
        contactSexLabel.text = contact["sex"] as? String
        contactPersonalInterestLabel.text = contact["personalInterest"] as? String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set status bar color
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    
}

