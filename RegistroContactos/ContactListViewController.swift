//
//  ContactListViewController.swift
//  RegistroContactos
//
//  Created by Jorge Rebollo J on 11/09/16.
//  Copyright © 2016 RGStudio. All rights reserved.
//

import UIKit
import CoreData

class ContactListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var ContactListTableView: UITableView!
    var contacts = [NSManagedObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 33/255, green: 208/255, blue: 195/255, alpha: 1.0)
    }
    
    override func viewWillAppear(animated: Bool) {
        requestData()
        ContactListTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set status bar color
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func requestData () {
        let mngdObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "Contactos")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try mngdObjectContext.executeFetchRequest(request)
            contacts = result as! [NSManagedObject]
        } catch let error as NSError {
            print("No se pudo guardar el contacto, tipo de error \(error)")
        }
    }
    
    //Replace both UITableViewDataSource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CustomContactCell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath) as! CustomContactCell
        let contact = contacts[indexPath.row]
        
        cell.contactNameLabel.text = contact.valueForKey("name") as? String
        cell.contactPhoneLabel.text = contact.valueForKey("telephone") as? String
        cell.contactInfoLabel.text = contact.valueForKey("personalInterest") as? String
        return cell
    }

}

