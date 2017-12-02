//
//  ProductsViewController.swift
//  Bring It!
//
//  Created by Administrador on 10/19/17.
//  Copyright © 2017 tec. All rights reserved.
//

import UIKit
import Alamofire

class ProductsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var nameShoppingList: UIBarButtonItem!
    var productsCurrent = [Product]()
    var alertController: UIAlertController!
    @IBOutlet weak var productsTableV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsCurrent = (Singlenton.instance.currentShoppingList?.products)!
        self.productsTableV.dataSource = self
        self.productsTableV.delegate = self
        self.title = Singlenton.instance.currentShoppingList?.name
        loadActionSheet()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let  viewController = storyBoard.instantiateViewController(withIdentifier: "HomeView") as! UITabBarController
        self.present(viewController, animated: true, completion: nil)
            
        
    }
    
  
    @IBAction func speechButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let  viewController = storyBoard.instantiateViewController(withIdentifier: "speechController") as! UINavigationController
        self.present(viewController, animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        productsTableV.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        numberRows = productsCurrent.count
        print(numberRows)

        return numberRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "productList", for: indexPath) as! ProductTableViewCell
      
        //myCell.nameShoppingListLabel.textColor = UIColor.white
        
        let product = productsCurrent[(indexPath as NSIndexPath).row]
        
        myCell.nameProductLabel.text! = product.name
        myCell.quantityProductLabel.text! = String(product.quantity)
        myCell.priceProductLabel.text! = String(product.price)
        
        
        
        return myCell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let more = UITableViewRowAction(style:.normal,title: "More", handler: {action, indexPath in
            Singlenton.instance.currentProductEdit = self.productsCurrent[(indexPath as NSIndexPath).row]
            self.present(self.alertController, animated:true, completion:nil)
        })
        let delete = UITableViewRowAction(style:.destructive,title: "Delete", handler: {action, indexPath in
            self.deleteProduct(tabRow: indexPath)
        })
        
        return [more, delete]
        
    }
    
    func loadActionSheet(){
        alertController = UIAlertController(title:"", message:"",preferredStyle:UIAlertControllerStyle.actionSheet)
     
        let editShoppingList = UIAlertAction(title:"Edit",style:UIAlertActionStyle.default){ (ACTION) -> Void in
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let  viewController = storyBoard.instantiateViewController(withIdentifier: "updateProduct") as! UINavigationController
            self.present(viewController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title:"Cancel",style:UIAlertActionStyle.cancel){ (ACTION) -> Void in
            
        }
        alertController.addAction(editShoppingList)
        alertController.addAction(cancelAction)
    }
    
    /////Revisar cierre de la ventana self.dismiss
    
    func deleteProduct(tabRow: IndexPath){
        
        let product = self.productsCurrent[tabRow.row]
       
        let concatenateResult = product.id + "/" + (Singlenton.instance.currentShoppingList?.id)!
        let url = URL(string: Constants.URL+Constants.DELETEPRODUCT+concatenateResult)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(urlRequest).responseJSON { response in
   
            if response.response?.statusCode == Constants.STATUS_OK
            {
                self.productsCurrent.remove(at: tabRow.row)
                self.productsTableV.reloadData()
                
            }else{
    
                self.printMessage(error: "Connection fail")
                
            }
            
        }
       
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toSegueProductAdd"{
            let destViewController = segue.destination as! UINavigationController
            let targetController = destViewController.topViewController as! RegisterProductTableViewController
            
            targetController.shoppingListId = (Singlenton.instance.currentShoppingList?.id)!
        }
    }
 

}
