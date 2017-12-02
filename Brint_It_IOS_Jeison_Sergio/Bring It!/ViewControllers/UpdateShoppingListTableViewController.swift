//
//  UpdateShoppingListTableViewController.swift
//  Bring It!
//
//  Created by Administrador on 11/14/17.
//  Copyright © 2017 tec. All rights reserved.
//

import UIKit
import Alamofire

class UpdateShoppingListTableViewController: UITableViewController, UITextFieldDelegate {

    
    @IBOutlet weak var nameShoppingListTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var notificationsSwitch: UISwitch!
   
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataShoppingList()
        createDatePicker()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func dateNotificationSwitch(_ sender: UISwitch) {
        if sender.isOn == true{
            self.dateTextField.isEnabled = true
        }else{
            self.dateTextField.isEnabled = false
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backHomeView(_ sender: Any) {
        Singlenton.instance.currentShoppingListEdit = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneUpdateShoppingList(_ sender: Any) {
        if validarDatos(){
            let datePicker = validateDatePicker()
            let name = self.nameShoppingListTextField.text
            if datePicker != "Fail"{
                if datePicker != "No date"{
                    let fullDatePicker = datePicker.components(separatedBy: ",")
                    updateShoppingList(name: name!,timeShopping: fullDatePicker[1],dateShopping: fullDatePicker[0])
                }else{
                    
                    updateShoppingList(name: name!,timeShopping: "No time",dateShopping: datePicker)
                }
                
            }
            
        }else{
            printMessage(error: "Empty spaces")
        }
        
    }
    
    func backStoryBoard() {
        Singlenton.instance.currentShoppingListEdit = nil
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let  viewController = storyBoard.instantiateViewController(withIdentifier: "HomeView") as! UITabBarController
        self.present(viewController, animated: true, completion: nil)
        
    }
    func setDataShoppingList(){
        let currentShoppingList = Singlenton.instance.currentShoppingListEdit
        if currentShoppingList != nil{
            self.nameShoppingListTextField.text = currentShoppingList?.name
            if currentShoppingList?.shopDate == "No date"{
                self.notificationsSwitch.isOn = false
                self.dateTextField.isEnabled = false
            }else{
                self.notificationsSwitch.isOn = true
                self.dateTextField.text = (currentShoppingList?.shopDate)! + ", " + (currentShoppingList?.shopTime)!
            }
            
        }
    }
    
    func updateShoppingList(name:String, timeShopping:String,dateShopping:String){
        let idCurrentShoppingList = (Singlenton.instance.currentShoppingListEdit?.id)!
        let parameters: Parameters = ["name": name,
                                      "shopDate": dateShopping,
                                      "shopTime":timeShopping]
        
        let url = URL(string: Constants.URL + Constants.UPDATESHOPPINGLIST + idCurrentShoppingList)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(urlRequest).responseJSON { response in
            print(response)
            if response.response?.statusCode == Constants.STATUS_OK
            {
                //self.printMessage(error: "Save successful")
                self.backStoryBoard()
            }else{
                
                self.printMessage(error: "Fail connection")
            }
            
        }
        
        
    }
    func validateDatePicker() -> String {
        
        if notificationsSwitch.isOn {
            if dateTextField.text != "" {
                return dateTextField.text!
            }else{
                printMessage(error: "Selected notification date")
                return "Fail"
            }
        }
        return "No date"
    }
    
    func printMessage(error:String){
        
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
        let accion = UIAlertAction(title: "Ok", style: .default){
            (action) -> Void  in
        }
        alert.addAction(accion)
        self.present(alert,animated:true,completion: nil)
        
    }
    func createDatePicker(){
        //format for picker
        datePicker.datePickerMode = .date
        
        //Create toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //Create bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
        
        //Assigning date picker to textField
        dateTextField.inputView = datePicker
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameShoppingListTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
        
        return true
    }
    
    func validarDatos()-> Bool {
        
        if self.nameShoppingListTextField.text == "" {
            
            return false
        }
        return true
    }
    
    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

}
