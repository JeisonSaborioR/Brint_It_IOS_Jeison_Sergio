//
//  ParserJSON.swift
//  Bring It!
//
//  Created by Administrador on 10/25/17.
//  Copyright © 2017 tec. All rights reserved.
//

import Foundation


class ParserJSON{
    
    static func parserJSONFacebookNetwork (data : Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let currentUser = json!["user"] as? [String: Any]
            let user = User(id: currentUser!["_id"] as! String, name: currentUser!["name"] as! String,email: currentUser!["email"]! as! String,passWord: "",userImage: currentUser!["userImage"] as! String)
       
            Singlenton.instance.currentUser = user

        
        }catch{
            
            print("Error")
        }
    }
    static func parserJSONUser (data : Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let currentUser = json!["user"] as? [String: Any]
            let user = User(id: currentUser!["_id"] as! String, name: currentUser!["name"] as! String,email: currentUser!["email"]! as! String,passWord:currentUser!["passWord"] as! String,userImage: currentUser!["userImage"] as! String)
            
            Singlenton.instance.currentUser = user
            
            
        }catch{
            
            print("Error")
        }
    }
    static func parserJSONShareUser (data : Data) -> User {
        
        var user : User? = nil
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let currentUser = json!["user"] as? [String: Any]
            user = User(id: currentUser!["_id"] as! String, name: currentUser!["name"] as! String,email: currentUser!["email"]! as! String,passWord:currentUser!["passWord"] as! String,userImage: currentUser!["userImage"] as! String)
            
        }catch{
            
            print("Error")
        }
        return user!
    }
    
    static func parserJSONProduct (data : Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let newProduct = json!["product"] as? [String: Any]
            let product = Product(id: newProduct!["_id"] as! String, name:newProduct!["name"] as! String, price: newProduct!["price"] as! Int64, image: newProduct!["image"] as! String,quantity: newProduct!["quantity"] as! Int64, isInCart: newProduct!["isInCart"]! as! Bool)
            deleteProduct(idProduct: product.id)
            Singlenton.instance.currentShoppingList?.products.append(product)
            
            
        }catch{
            
            print("Error")
        }
    }
    
    static func deleteProduct(idProduct: String){
       
        let currentProducts = (Singlenton.instance.currentShoppingList?.products)!
        for (i,product) in currentProducts.enumerated().reversed(){
            if product.id == idProduct{
                Singlenton.instance.currentShoppingList?.products.remove(at: i)
            }
        }
    }
    
    
    
    
    
    
    static func parserJSONShoppingListUser(data : Data) {
      
        do{
            
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            let shoppingListUser = json as? [AnyObject] ?? []
            print(shoppingListUser)
            for shoppingList in shoppingListUser{
                
                var productsList = [Product]()
                let name = shoppingList["name"] as? String
                let id = shoppingList["_id"] as? String
                let amount = shoppingList["amount"] as? Double
                let shopDate = shoppingList["shopDate"] as? String
                let idUser = shoppingList["idUser"] as? String
                let shopTime = shoppingList["shopTime"] as? String
        
                let products = shoppingList["products"] as? [AnyObject] ?? []

                if products.count > 0{
                    
                    for product in products{
                        let idProduct = product["_id"] as? String
                        let nameProduct = product["name"] as? String
                        let price = product["price"] as? Int64
                        let image = product["image"] as? String
                        let quantity = product["quantity"] as? Int64
                        let isInCart = product["isInCart"] as? Bool
                        
                        let newProduct = Product(id:idProduct!,name: nameProduct!,price:price!,image:image!, quantity:quantity!, isInCart:isInCart!)
                        productsList.append(newProduct)
                        
                    }
                    let newShoppingList = ShoppingList(name: name!,id: id!,idUser: idUser!, shopDate:shopDate!,shopTime:shopTime!, amount:amount!,products: productsList)
                    
                    Singlenton.instance.arrayAllShoppingList.append(newShoppingList)
                }else{
                    let newShoppingList = ShoppingList(name: name!,id: id!,idUser: idUser!, shopDate:shopDate!,shopTime:shopTime!, amount:amount!,products: productsList)
                    Singlenton.instance.arrayAllShoppingList.append(newShoppingList)
                }
            }
      
            
        }catch{
            
            print("Error")
        }
    }

}
