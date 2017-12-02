//
//  AddProductTableViewController.swift
//  Bring It!
//
//  Created by Administrador on 11/8/17.
//  Copyright © 2017 tec. All rights reserved.
//

import UIKit
import Alamofire

class RegisterProductTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var nameProductTextField: UITextField!
    @IBOutlet weak var priceProductTextField: UITextField!
    @IBOutlet weak var quantityProductTextField: UITextField!
    var shoppingListId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.priceProductTextField.delegate = self
        self.quantityProductTextField.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let charactersSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: charactersSet)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func startStoryBoard() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ProductList") 
        //self.present(viewController, animated: true, completion: nil)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func saveProductButton(_ sender: Any) {
        if validarDatos(){
            let nameProduct = self.nameProductTextField.text
            let priceProduct = Int64(self.priceProductTextField.text!)
            let quantityProduct = Int64(self.quantityProductTextField.text!)
            postSaveProduct(name:nameProduct!, price: priceProduct!,quantity: quantityProduct!)
            
        }else{
            printMessage(error: "Empty spaces")
        }
    }
    
    func postSaveProduct(name:String, price:Int64,quantity:Int64){
        
        let parameters: Parameters = ["name": name,
                                      "price": price,
                                      "quantity":quantity,
                                      "idShopList":shoppingListId]
        
        let url = URL(string: Constants.URL + Constants.POSTPRODUCT)!
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
                ParserJSON.parserJSONProduct(data: response.data!)
                self.startStoryBoard()
            }else{
                
                self.printMessage(error: "Connection fail")
            }
            
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameProductTextField.resignFirstResponder()
        priceProductTextField.resignFirstResponder()
        quantityProductTextField.resignFirstResponder()
        
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
        if self.nameProductTextField.text == "" || self.priceProductTextField.text == "" || self.quantityProductTextField.text == "" {
            
            return false
        }
        return true
    }
    
    
    
    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
*/
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

}
