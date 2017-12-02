//
//  ShoppingList.swift
//  Bring It!
//
//  Created by Administrador on 10/29/17.
//  Copyright © 2017 tec. All rights reserved.
//

import Foundation

struct ShoppingList {
    
    var name:String
    var id:String
    var idUser:String
    var shopDate: String
    var shopTime: String
    var amount:Double
    var products = [Product]()
}
