//
//  Constants.swift
//  Bring It!
//
//  Created by Administrador on 10/25/17.
//  Copyright © 2017 tec. All rights reserved.
//

import Foundation

/*

 //EndPoints para los Usuarios
 api.post('/saveUser',userCtrl.saveUser)
 api.post('/loginSocialNetwork',userCtrl.loginSocialNetwork)
 api.post('/authenticate',userCtrl.signIn)
 api.get('/getUsers',userCtrl.getUsers)
 
 
 
 
 //EndPoints para los productos
 
 api.post('/saveProduct',productCtrl.saveProduct)
 api.delete('/deleteProduct/:idProduct', productCtrl.deleteProduct)
 api.put('/updateProduct/:idProduct',productCtrl.updateProduct)
 api.put('/updateStateProduct',productCtrl.updateStateProduct)
 
 
 
 //EndPoints para listas de compras
 
 api.post('/saveShopList',shopListCtrl.saveShopList)
 api.get('/getShopLists',shopListCtrl.getShopLists)
 api.get('/getShopListsUser/:idUser', shopListCtrl.getShopListUser)
 api.delete('/deleteShopList/:idShopList', shopListCtrl.deleteShopList)
 api.put('/updateShopList/:idShopList',shopListCtrl.updateShopList)
 api.post('/shareShopList',shopListCtrl.updateShopListArrayUsers)
 
*/
class Constants {
    
    
   
    //Rest service
    static var URL = "https://listas-comprasb.herokuapp.com/"
    static var POSTSOCIALNETWORK = "loginSocialNetwork/"
    static var POSTUSER = "saveUser/"
    static var POSTSHOPPINGLIST = "saveShopList/"
    static var POSTPRODUCT = "saveProduct/"
    static var GETUSERSHOPPINGLIST = "getShopListsUser/"
    static var GETUSER = "getUser/"
    static var USERAUTHENTICATE = "authenticate/"
    static var SHOPPINGLIST_USER = "getShopLists/"
    static var DELETEPRODUCT = "deleteProduct/"
    static var DELETESHOPPINGLIST = "deleteShopList/"
    static var SHARESHOPPINGLIST = "shareShopList/"
    static var UPDATESHOPPINGLIST = "updateShopList/"
    static var UPDATEPRODUCT = "updateProduct/"
    
    static var ARRAYNUMBERS = [Number(number:"1", numberLetter:"Un"),
                               Number(number:"1", numberLetter:"Uno"),
                               Number(number:"2", numberLetter:"Dos"),
                               Number(number:"3", numberLetter:"Tres"),
                               Number(number:"4", numberLetter:"Cuatro"),
                               Number(number:"5", numberLetter:"Cinco"),
                               Number(number:"6", numberLetter:"Seis"),
                               Number(number:"7", numberLetter:"Siete"),
                               Number(number:"8", numberLetter:"Ocho"),
                               Number(number:"9", numberLetter:"Nueve"),
                               Number(number:"10", numberLetter:"Diez"),
                               Number(number:"11", numberLetter:"Once"),
                               Number(number:"12", numberLetter:"Doce"),
                               Number(number:"13", numberLetter:"Trece"),
                               Number(number:"14", numberLetter:"Catorce"),
                               Number(number:"15", numberLetter:"15"),
                               Number(number:"16", numberLetter:"16"),
                               Number(number:"17", numberLetter:"17"),
                               Number(number:"18", numberLetter:"18"),
                               Number(number:"19", numberLetter:"19"),
                               Number(number:"20", numberLetter:"20")
                               ]
   //Regular expression to validate the user email input
    /*
    static var PATTERN_EMAIL = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
    + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*$";
    */
    static var PATTERN_EMAIL = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static var PATTERN_PASSWORD = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)([A-Za-z\\d]){8,12}$"
    
    static var STATUS_OK: Int = 200
   
 
}
