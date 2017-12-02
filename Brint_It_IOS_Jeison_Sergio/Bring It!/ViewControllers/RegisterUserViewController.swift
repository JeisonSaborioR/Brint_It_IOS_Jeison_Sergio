//
//  RegisterUserViewController.swift
//  Bring It!
//
//  Created by Administrador on 11/1/17.
//  Copyright © 2017 tec. All rights reserved.
//

import UIKit
import Alamofire
class RegisterUserViewController: UIViewController, UITextFieldDelegate {

 
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var confirmPassWordTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func backMenuButton(_ sender: Any) {
 
        self.dismiss(animated: true, completion: nil)
      
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    func StartStoryBoard() {
        
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isLogged")
        
        defaults.set(Singlenton.instance.currentUser?.id, forKey: "idUser")
        defaults.set(Singlenton.instance.currentUser?.name, forKey: "nameUser")
        defaults.set(Singlenton.instance.currentUser?.email, forKey: "emailUser")
        defaults.set(Singlenton.instance.currentUser?.userImage, forKey: "imageUser")
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let  viewController = storyBoard.instantiateViewController(withIdentifier: "HomeView") as! UITabBarController
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    @IBAction func registerBto(_ sender: Any) {
        
        //let confirmPass : String! = self.confirmPass.text!
        if validarDatos(){
            let name = self.nameTextField.text
            let email = self.emailTextField.text
            let passW = self.passWordTextField.text
            let confirmPassword = self.confirmPassWordTextField.text
            
            if isPasswordValid(password: passW!) {
                if isEmailValid(email: email!){
                    if passW == confirmPassword{
                        postSaveUser(passWord: passW!,email: email!,name:name!)
                    }else{
                        printMessage(error: "Password and confirm password are diferent")
                    }
                }else{
                    printMessage(error: "Email is not formatted properly")
                }
            }else{
                printMessage(error: "Your password must be 8-12 characters and include at least one uppercase letter and a number")
            }
          
        }else{
            printMessage(error: "Empty spaces")
            
        }
        
    }
    
  
    
    func postSaveUser(passWord:String, email:String,name:String){
 
        let parameters: Parameters = ["email": email,
                                      "name": name,
                                      "password":passWord,
                                      "userImage": "#"]
        
        let url = URL(string: Constants.URL + Constants.POSTUSER)!
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
                ParserJSON.parserJSONUser(data: response.data!)
                self.StartStoryBoard()
            }else{
                
                self.printMessage(error: "Connection fail")
            }
            
        }
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passWordTextField.resignFirstResponder()
        confirmPassWordTextField.resignFirstResponder()
        return true
    }
    
    func clearTextField(){
        self.nameTextField.text = ""
        self.emailTextField.text = ""
        self.passWordTextField.text = ""
        self.confirmPassWordTextField.text = ""
        
    }
    

    func validarDatos()-> Bool {
        
        if self.emailTextField.text == "" || self.passWordTextField.text == ""
            || self.confirmPassWordTextField.text == ""
            || self.nameTextField.text == ""{
            
            return false
        }
        return true
    }
    
    func isPasswordValid(password : String) -> Bool{
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", Constants.PATTERN_PASSWORD)
        return passwordTest.evaluate(with: password)
    }
    
    func isEmailValid(email : String) -> Bool{
        let emailTest = NSPredicate(format: "SELF MATCHES %@", Constants.PATTERN_EMAIL)
        return emailTest.evaluate(with: email)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
