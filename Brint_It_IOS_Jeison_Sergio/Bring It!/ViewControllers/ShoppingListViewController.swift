//
//  ShoppingListViewController.swift
//  Bring It!
//
//  Created by Administrador on 10/19/17.
//  Copyright © 2017 tec. All rights reserved.
//

import UIKit
import Alamofire


class ShoppingListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
   
    var arrayAllShoppingList = [ShoppingList]()
    var arrayUserCurrentShoppingList = [ShoppingList]()
    var alertController: UIAlertController!
    var emailShareShoppinList:UITextField? = nil
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var shoppingListTableV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.hidesWhenStopped = true
        self.shoppingListTableV.dataSource = self
        self.shoppingListTableV.delegate = self
        loadActionSheet()
     
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    func emailShareShoppingList(textField:UITextField){
        emailShareShoppinList = textField
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        Singlenton.instance.arrayAllShoppingList = []
        
        if currentReachabilityStatus == .reachableViaWWAN{
            self.getShoppingList()
        }else if currentReachabilityStatus == .reachableViaWiFi{
            self.getShoppingList()
        }else{
            printMessageInternet(error: "Could not connect to the server Check your Internet connection and try again")
        }
        
        self.shoppingListTableV.reloadData()
    }
    
    
    func getShoppingList() {
        self.activityIndicator.startAnimating()
        let urlRequest = Constants.URL + Constants.GETUSERSHOPPINGLIST + (Singlenton.instance.currentUser?.id)!
        
        Alamofire.request(urlRequest).responseJSON { response in
            if response.response?.statusCode == Constants.STATUS_OK{
                ParserJSON.parserJSONShoppingListUser(data:response.data!)
                self.shoppingListTableV.reloadData()
                self.activityIndicator.stopAnimating()
           
            }else{
                
                self.printMessage(error: "Connection fail")
            
            }
        }
        
    }
    
    func printMessageInternet(error:String){
        
        let alert = UIAlertController(title: "Error de conexión", message: error, preferredStyle: .alert)
        let accion = UIAlertAction(title: "Retry", style: .default){
            (action) -> Void  in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let  viewController = storyBoard.instantiateViewController(withIdentifier: "HomeView") as! UITabBarController
            self.present(viewController, animated: true, completion: nil)
        }
        alert.addAction(accion)
        self.present(alert,animated:true,completion: nil)
        
   
    }
    
    func printMessage(error:String){
        
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
        let accion = UIAlertAction(title: "Ok", style: .default){
            (action) -> Void  in
        }
        alert.addAction(accion)
        self.present(alert,animated:true,completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberRows: Int = 0
        
        numberRows = Singlenton.instance.arrayAllShoppingList.count
   
        return numberRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "shoppingList", for: indexPath) as! ShoppingListTableViewCell
        
        let shopList = Singlenton.instance.arrayAllShoppingList[(indexPath as NSIndexPath).row]
    
        myCell.nameShoppingListLabel.text! = shopList.name
        myCell.dateShoppingListLabel.text! = shopList.shopDate
        
        return myCell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let more = UITableViewRowAction(style:.normal,title: "More", handler: {action, indexPath in
            Singlenton.instance.currentShoppingListEdit = Singlenton.instance.arrayAllShoppingList[(indexPath as NSIndexPath).row]
            self.present(self.alertController, animated:true, completion:nil)
        })
        let delete = UITableViewRowAction(style:.destructive,title: "Delete", handler: {action, indexPath in
            self.deleteShoppingList(tabRow: indexPath)
        })
        
        return [more, delete]
        
    }
    
    func loadActionSheet(){
        alertController = UIAlertController(title:"", message:"",preferredStyle:UIAlertControllerStyle.actionSheet)
        let sharedShoppinList = UIAlertAction(title:"Share",style:UIAlertActionStyle.default){ (ACTION) -> Void in
            self.shareShoppingList()
        }
        let editShoppingList = UIAlertAction(title:"Edit",style:UIAlertActionStyle.default){ (ACTION) -> Void in
        
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let  viewController = storyBoard.instantiateViewController(withIdentifier: "RegisterShoppingList") as! UINavigationController
            self.present(viewController, animated: true, completion: nil)
           
        }
        let cancelAction = UIAlertAction(title:"Cancel",style:UIAlertActionStyle.cancel){ (ACTION) -> Void in
         
        }
        alertController.addAction(sharedShoppinList)
        alertController.addAction(editShoppingList)
        alertController.addAction(cancelAction)
    }
    
    func shareShoppingList(){
        let alert = UIAlertController(title: "Share shopping list",
                                      message: "",
                                      preferredStyle: .alert)
        // Submit button
        let submitAction = UIAlertAction(title: "Share", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = alert.textFields![0]
            let email = textField.text!
            if email == ""{
                self.printMessage(error: "Email address empty")
            }else{
                self.getShareUser(emailAddress: email)
            }
            
         
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        // Add 1 textField and customize it
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Email address"
            textField.clearButtonMode = .whileEditing
        }
        // Add action buttons and present the Alert
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
      
    }
    
    func shareShoppingList(userShare:User){
        let idShoppingList = Singlenton.instance.currentShoppingListEdit?.id
        let url = URL(string: Constants.URL + Constants.SHARESHOPPINGLIST + idShoppingList!)!
       
        let parameters: Parameters = ["idUser": userShare.id]
        
        var urlRequest = URLRequest(url: url)
        
   
        print(parameters)
        urlRequest.httpMethod = "PUT"
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(urlRequest).responseJSON { response in
            
            if response.response?.statusCode == Constants.STATUS_OK
            {
                self.printMessage(error: "It was successfully shared")
            }else{
                
                self.printMessage(error: "Connection fail")
            }
            
        }
        
    }
    
    func getShareUser(emailAddress: String){
        let urlRequest = Constants.URL + Constants.GETUSER + emailAddress
     
        Alamofire.request(urlRequest).responseJSON { response in
            if response.response?.statusCode == Constants.STATUS_OK{
                let userShare = ParserJSON.parserJSONShareUser(data:response.data!)
                self.shareShoppingList(userShare: userShare)
            }else{
                
                self.printMessage(error: "Connection fail")
                
            }
        }
    }
    
    func deleteShoppingList(tabRow: IndexPath){
        
        let shoppingList = Singlenton.instance.arrayAllShoppingList[tabRow.row]
        let url = URL(string: Constants.URL+Constants.DELETESHOPPINGLIST+String(shoppingList.id))!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
      
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(urlRequest).responseJSON { response in
           
            if response.response?.statusCode == Constants.STATUS_OK
            {
                Singlenton.instance.arrayAllShoppingList.remove(at: tabRow.row)
                self.shoppingListTableV.reloadData()
            }else{
                
                self.printMessage(error: "Connection fail")
            }
            
        }
    
    }

/*
    private func tableView(_ tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toSegueProductsShopList"{
            let indexPath = shoppingListTableV.indexPathForSelectedRow! as IndexPath
            Singlenton.instance.currentShoppingList = Singlenton.instance.arrayAllShoppingList[(indexPath as NSIndexPath).row]
        }
        
    }
}
