//
//  NewContactViewController.swift
//  RegistroContactos
//
//  Created by Jorge Rebollo J on 11/09/16.
//  Copyright © 2016 RGStudio. All rights reserved.
//

import UIKit
import CoreData

class NewContactViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var sexAndCivilStatusPicker: UIPickerView!
    @IBOutlet weak var personalInterestTextView: UITextView!
    @IBOutlet weak var addContactButton: UIButton!
    
    var pickerContents:[[String]] = []
    let sexAndCivilStatus = ["Estado civil","Solter@","Casad@","Divorsiad@","Unión libre","Viud@","Otr@"]
    let sex = ["Sexo","Hombre","Mujer"]
    var sexSelected = ""
    var civilStatusSelected = ""
    var contactos = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        phoneTextField.delegate = self
        addDoneButtonOnKeyboard()
        sexAndCivilStatusPicker.dataSource = self
        sexAndCivilStatusPicker.delegate = self
        pickerContents = [sexAndCivilStatus,sex]
        personalInterestTextView.delegate = self
        let myColor : UIColor = UIColor.init(colorLiteralRed: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)
        personalInterestTextView.layer.borderColor = myColor.CGColor
        personalInterestTextView.layer.borderWidth = 1.0
        personalInterestTextView.layer.cornerRadius = 5.0
        personalInterestTextView.text = "Intereses personales..."
        personalInterestTextView.textColor = UIColor.lightGrayColor()
        addContactButton.enabled = false
        addContactButton.backgroundColor = UIColor.grayColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewContactViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewContactViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set status bar color
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // Set textfields
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (nameTextField.isFirstResponder()) {
            phoneTextField.becomeFirstResponder()
        } else {
            phoneTextField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        validateInfo()
    }
    
    // Set done button on phone pad keyboard
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Aceptar", style: UIBarButtonItemStyle.Done, target: self, action: #selector(NewContactViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        phoneTextField.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction() {
        phoneTextField.resignFirstResponder()
    }
    
    // Set picker
    func numberOfComponentsInPickerView(bigPicker: UIPickerView) -> Int{
        return pickerContents.count
    }
    
    // returns the # of rows in each component..
    func pickerView(bigPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerContents[component].count
    }
    
    func pickerView(bigPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return pickerContents[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerContents[component][row]
        if row == 0 {
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 14.0)!,NSForegroundColorAttributeName:UIColor.init(colorLiteralRed: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)])
            return myTitle
        } else {
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 14.0)!,NSForegroundColorAttributeName:UIColor.init(colorLiteralRed: 250/255, green: 210/255, blue: 77/255, alpha: 1.0)])
            return myTitle
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if row != 0 {
            sexSelected = pickerContents[0][row]
            civilStatusSelected = pickerContents[1][row]
        } else {
            sexSelected = ""
            civilStatusSelected = ""
        }
        validateInfo()
        
    }
    
    // Set textview
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            personalInterestTextView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if personalInterestTextView.textColor == UIColor.lightGrayColor() {
            personalInterestTextView.text = nil
            personalInterestTextView.textColor = UIColor.init(colorLiteralRed: 250/255, green: 210/255, blue: 77/255, alpha: 1.0)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if personalInterestTextView.text.isEmpty {
            personalInterestTextView.text = "Intereses personales..."
            personalInterestTextView.textColor = UIColor.lightGrayColor()
        }
        validateInfo()
    }
    
    // Set resign textflieds and text view responder
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        nameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        personalInterestTextView.resignFirstResponder()
    }
    
    // Set keyboard management
    func keyboardWillShow(notification: NSNotification) {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 150
        }
        if personalInterestTextView.isFirstResponder() {
            self.view.frame.origin.y -= personalInterestTextView.frame.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y += 150
        }
        if personalInterestTextView.isFirstResponder() {
            self.view.frame.origin.y += personalInterestTextView.frame.height
        }
    }
    
    // Validate fields to add contact
    func validateInfo() {
        if nameTextField.text != "" && phoneTextField.text != "" && !sexSelected.isEmpty && !civilStatusSelected.isEmpty {
            addContactButton.enabled = true
            addContactButton.backgroundColor = UIColor.init(colorLiteralRed: 255/255, green: 88/255, blue: 75/255, alpha: 1.0)
        } else {
            addContactButton.enabled = false
            addContactButton.backgroundColor = UIColor.grayColor()
        }
    }
    
    @IBAction func addContactButtonAction(sender: AnyObject) {
        tabBarController?.selectedIndex = 0
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Contactos", inManagedObjectContext:managedContext)
        
        let contacto = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        contacto.setValue(nameTextField.text, forKey: "name")
        contacto.setValue(phoneTextField.text, forKey: "telephone")
        contacto.setValue(sexSelected, forKey: "sex")
        contacto.setValue(civilStatusSelected, forKey: "civilStatus")
        contacto.setValue(personalInterestTextView.text, forKey: "personalInterest")
        
        do {
            try managedContext.save()
            contactos.append(contacto)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // Remove observers
    override func viewWillDisappear(animated: Bool) {
        nameTextField.text = nil
        phoneTextField.text = nil
        sexSelected = ""
        civilStatusSelected = ""
        personalInterestTextView.text = "Intereses personales..."
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }

}

