//
//  UpdateProductTableViewController.swift
//  Bring It!
//
//  Created by Administrador on 11/14/17.
//  Copyright © 2017 tec. All rights reserved.
//

import UIKit
import Alamofire

class UpdateProductTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var nameProductTextField: UITextField!
    
    @IBOutlet weak var priceProductTextField: UITextField!
    
    @IBOutlet weak var quantityProductTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataProduct()
        self.priceProductTextField.delegate = self
        self.quantityProductTextField.delegate = self
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setDataProduct(){
        let currentProduct = Singlenton.instance.currentProductEdit
        if currentProduct != nil{
            self.nameProductTextField.text = currentProduct?.name
            self.priceProductTextField.text = String(describing: currentProduct!.price)
            self.quantityProductTextField.text = String(describing: currentProduct!.quantity)
        }
    }
    
    func startStoryBoard() {
        Singlenton.instance.currentProductEdit = nil
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ProductList")
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        self.present(navigationController, animated: true, completion: nil)
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let charactersSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: charactersSet)
    }
    
    @IBAction func CancelButton(_ sender: Any) {
         Singlenton.instance.currentProductEdit = nil
         self.dismiss(animated: true, completion: nil)
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
        let currentProductId = Singlenton.instance.currentProductEdit?.id
        
        let parameters: Parameters = ["name": name,
                                      "price": price,
                                      "quantity":quantity
                                      ]
        
        let url = URL(string: Constants.URL + Constants.UPDATEPRODUCT+currentProductId!)!
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
    

}
