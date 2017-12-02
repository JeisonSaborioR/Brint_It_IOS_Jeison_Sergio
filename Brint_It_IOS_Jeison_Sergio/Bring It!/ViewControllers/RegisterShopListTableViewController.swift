//
//  RegisterShopListTableViewController.swift
//  Bring It!
//
//  Created by Administrador on 11/4/17.
//  Copyright © 2017 tec. All rights reserved.
//

import UIKit
import Alamofire

class RegisterShopListTableViewController: UITableViewController, UITextFieldDelegate  {

    @IBOutlet weak var nameShoppingListTextField: UITextField!
    @IBOutlet weak var datePickerTxtField: UITextField!

    @IBAction func activeNotificationSwitch(_ sender: UISwitch) {
        if sender.isOn == true{
            self.datePickerTxtField.isEnabled = true
            
        }else{
            self.datePickerTxtField.isEnabled = false
            
        }
    }
    
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        createDatePicker()
        
    }
    
    
    @IBAction func cancelBto(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func postShoppingListBto(_ sender: Any) {
        if validarDatos(){
            let datePicker = validateDatePicker()
            let name = self.nameShoppingListTextField.text
            if datePicker != "Fail"{
                if datePicker != "No date"{
                    let fullDatePicker = datePicker.components(separatedBy: ",")
                    postShoppingList(name: name!,timeShopping: fullDatePicker[1],dateShopping: fullDatePicker[0])
                }else{
                    
                    postShoppingList(name: name!,timeShopping: "No time",dateShopping: datePicker)
                }
               
            }
            
        }else{
            printMessage(error: "Empty spaces")
        }
    }
    
    func postShoppingList(name:String, timeShopping:String,dateShopping:String){
        let idCurrentUser = (Singlenton.instance.currentUser?.id)!
        let parameters: Parameters = ["name": name,
                                      "shopDate": dateShopping,
                                      "shopTime":timeShopping,
                                      "idUser": idCurrentUser]
        
        let url = URL(string: Constants.URL + Constants.POSTSHOPPINGLIST)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
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
    func backStoryBoard() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let  viewController = storyBoard.instantiateViewController(withIdentifier: "HomeView") as! UITabBarController
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    func validateDatePicker() -> String {
        if datePickerTxtField.isEnabled {
            if datePickerTxtField.text != "" {
                return datePickerTxtField.text!
            }else{
                printMessage(error: "Selected notification date")
                return "Fail"
            }
        }
        return "No date"
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
        datePickerTxtField.inputAccessoryView = toolbar
        
        //Assigning date picker to textField
        datePickerTxtField.inputView = datePicker
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      nameShoppingListTextField.resignFirstResponder()
          datePickerTxtField.resignFirstResponder()
        
        return true
    }
    
    
   
    func printMessage(error:String){
        
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
        let accion = UIAlertAction(title: "Ok", style: .default){
            (action) -> Void  in
        }
        alert.addAction(accion)
        self.present(alert,animated:true,completion: nil)
        
    }
    
    func validarDatos()-> Bool {
        
        if self.nameShoppingListTextField.text == "" {
            
            return false
        }
        return true
    }
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
     
*/
    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        
  
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        
        datePickerTxtField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

}
