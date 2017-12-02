//
//  CustomTextField.swift
//  Bring It!
//
//  Created by Administrador on 11/1/17.
//  Copyright © 2017 tec. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1.5
        self.backgroundColor = UIColor.blue
        self.tintColor = UIColor.white
    }
    

}
