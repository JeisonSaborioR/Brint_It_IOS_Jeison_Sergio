//
//  SettingsTableViewController.swift
//  Bring It!
//
//  Created by Administrador on 11/4/17.
//  Copyright © 2017 tec. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Google

class SettingsTableViewController: UITableViewController {

   
    @IBOutlet weak var userCurrenIUImage: UIImageView!
    
    @IBOutlet weak var emailUserCurrentLabel: UILabel!
    @IBOutlet weak var nameUserCurrentLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfile()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        userCurrenIUImage.layer.cornerRadius = userCurrenIUImage.frame.size.width/2
        userCurrenIUImage.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        ///Log out user
        if indexPath.row == 5{
            //Log Out user
            
            FBSDKLoginManager().logOut()
            
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "isLogged")
          
            defaults.removeObject(forKey: "idUser")
            defaults.removeObject(forKey: "nameUser")
            defaults.removeObject(forKey: "emailUser")
            defaults.removeObject(forKey: "imageUser")
            defaults.synchronize()
       
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let  viewController = storyBoard.instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
            self.present(viewController, animated: true, completion: nil)
            
        }
        
    }
    
    func decodeBase64(toImage strEncodeData: String) -> UIImage {
        let dataDecoded  = NSData(base64Encoded: strEncodeData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        let image = UIImage(data: dataDecoded as Data)
        return image!
    }
    
    func loadProfile() {
        let userImage = Singlenton.instance.currentUser?.userImage
        if Singlenton.instance.currentUser != nil {
            if  userImage != nil && userImage != "#" && userImage != "" {
                let url = NSURL(string:(userImage)!)
                let data = NSData(contentsOf:url! as URL)
                userCurrenIUImage.image = UIImage(data: data! as Data)
            }else{
                userCurrenIUImage.image = #imageLiteral(resourceName: "UserImage")
            }
            
            emailUserCurrentLabel.text = Singlenton.instance.currentUser?.name
            nameUserCurrentLabel.text = Singlenton.instance.currentUser?.email
            
        }
       
    }


}
