//
//  LoginViewController.swift
//  Bring It!
//
//  Created by Administrador on 10/20/17.
//  Copyright © 2017 tec. All rights reserved.
//

import UIKit
import GoogleSignIn
import Google
import FBSDKLoginKit
import Alamofire

/**
 GIDSignInUIDelegate, GIDSignInDelegate: delegate para el logueo con la api GOOGLE
 FBSDKLoginButtonDelegate: delegate para el logueo con la api FACEBOOK
 Clase que permite el logue normal, facebook y google autentificando el acceso a
 los usuarios a la aplicaciòn.
 */
class LoginViewController: UIViewController, GIDSignInUIDelegate,GIDSignInDelegate, FBSDKLoginButtonDelegate, UITextFieldDelegate   {

    
    @IBOutlet weak var emailTxtF: UITextField!
    @IBOutlet weak var passwordTxtF: UITextField!
    @IBOutlet weak var facebookBto: FBSDKLoginButton!
    @IBOutlet weak var googleView: GIDSignInButton!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
        
        var error: NSError?
        
        GGLContext.sharedInstance().configureWithError(&error)
        if error != nil{
            print(error as Any)
            return
        }
 
        
       GIDSignIn.sharedInstance().uiDelegate = self
       GIDSignIn.sharedInstance().delegate = self
       
        
       facebookBto.delegate = self
       facebookBto.readPermissions = ["email","public_profile"]
 
    }
 
    func postSocialNetwork(data: User){
        let parameters: Parameters = ["email": data.email,
                                      "name": data.name,
                                      "userImage": data.userImage]
        
        let url = URL(string: Constants.URL + Constants.POSTSOCIALNETWORK)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(urlRequest).responseJSON { response in
            
            if response.response?.statusCode == Constants.STATUS_OK
            {
                
                
                ParserJSON.parserJSONFacebookNetwork(data: response.data!)
                self.StartStoryBoard()
                
            }else{
                FBSDKLoginManager().logOut()
                self.printMessage(error: "Connection fail")
            }
            
        }
    
    }


func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    
    if error == nil {
        self.activityIndicator.startAnimating()
        Singlenton.instance.socialNetwork = "Facebook"
        profileUser()
    }
    
    
}


@IBAction func SignInBto(_ sender: Any) {
   
    self.activityIndicator.startAnimating()
    
    if validarDatos(){
        let email : String! = self.emailTxtF.text!
        let passWord : String! = self.passwordTxtF.text!
        
        if isPasswordValid(password: passWord!) {
            if isEmailValid(email: email!){
                authenticateUser(email: email, passWord: passWord)
            }else{
                 self.activityIndicator.stopAnimating()
                printMessage(error: "Email is not formatted properly")
            }
        }else{
             self.activityIndicator.stopAnimating()
            printMessage(error: "Your password must be 8-12 characters and include at least one uppercase letter and a number")
        }
        
        
        
    }else{
        printMessage(error: "Empty spaces")
        self.activityIndicator.stopAnimating()
        //self.activityIndicator.stopAnimating()
    }
    
    
}
    func printMessage(error:String){
        
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
        let accion = UIAlertAction(title: "Ok", style: .default){
            (action) -> Void  in
        }
        alert.addAction(accion)
        self.present(alert,animated:true,completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTxtF.resignFirstResponder()
        passwordTxtF.resignFirstResponder()
        
        return true
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil {
            print(error ?? "Some error")
            return
        }
       self.activityIndicator.startAnimating()
        
        var tempImage = ""
        Singlenton.instance.socialNetwork = "Google"
        let emailUser = user.profile.email
        let nameUser = user.profile.name
        
        if let imageUser = user.profile.imageURL(withDimension: 400){
            
            tempImage = imageUser.absoluteString
        }
        let user = User(id:"",name: nameUser!,email: emailUser!,passWord: "",userImage: tempImage)
        self.postSocialNetwork(data: user)
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
          FBSDKLoginManager().logOut()
    }
    
    //Levanta vista homeView directamente desde el storyBoard
    func StartStoryBoard() {
        
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isLogged")
        
        
        defaults.set(Singlenton.instance.currentUser?.id, forKey: "idUser")
        defaults.set(Singlenton.instance.currentUser?.name, forKey: "nameUser")
        defaults.set(Singlenton.instance.currentUser?.email, forKey: "emailUser")
        defaults.set(Singlenton.instance.currentUser?.userImage, forKey: "imageUser")
        self.activityIndicator.stopAnimating()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let  viewController = storyBoard.instantiateViewController(withIdentifier: "HomeView") as! UITabBarController
        self.present(viewController, animated: true, completion: nil)
    
    }
    
    func profileUser(){
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "email, first_name, name, last_name,gender,picture"]).start {
            (connection,result,err) in
            if err != nil {
                self.printMessage(error: "Connection fail")
            }
            
            if let result = result as? [String: Any]
            {
                var tempImage = ""
                let emailUser = result["email"] as? String
                let nameUser = result["name"] as? String
                if let imageUser = ((result["picture"] as? [String: Any])? ["data"] as? [String: Any])? ["url"] as? String {
                    tempImage = imageUser
                }
                let user = User(id:"",name: nameUser!,email: emailUser!,passWord: "",userImage: tempImage)
                self.postSocialNetwork(data: user)
               
            }
        }
    
    }
  
   
    
    
    
    func authenticateUser(email:String,passWord:String){
        let parameters: Parameters = ["email": email,
                                      "password": passWord
                                      ]
        let url = URL(string: Constants.URL+Constants.USERAUTHENTICATE)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(urlRequest).responseJSON { response in
            
            if response.response?.statusCode == Constants.STATUS_OK
            {
                
                ParserJSON.parserJSONFacebookNetwork(data: response.data!)
                
                 self.StartStoryBoard()
                
            }else{
            self.activityIndicator.startAnimating()
                self.printMessage(error: "The username or password you’ve entered is incorrect. ")
            }
            
        }
        
    }
    
    
    func isPasswordValid(password : String) -> Bool{
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", Constants.PATTERN_PASSWORD)
        return passwordTest.evaluate(with: password)
    }
    
    func isEmailValid(email : String) -> Bool{
        let emailTest = NSPredicate(format: "SELF MATCHES %@", Constants.PATTERN_EMAIL)
        return emailTest.evaluate(with: email)
    }
    
    func validarDatos()-> Bool {
        
        if self.emailTxtF.text == "" || self.passwordTxtF.text == ""{
            
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
