//
//  Singlenton.swift
//  Bring It!
//
//  Created by Administrador on 10/31/17.
//  Copyright © 2017 tec. All rights reserved.
//

import Foundation

final class Singlenton{
    
    var arrayAllShoppingList = [ShoppingList]()
    var currentUser: User? = nil
    var socialNetwork: String = ""
    var currentShoppingList: ShoppingList? = nil
    var currentShoppingListEdit: ShoppingList? = nil
    var currentProductEdit: Product? = nil
    var arrayAllUser = [User]()
    
    static let instance = Singlenton()
    
    private init(){
    }
    
 
    
}

