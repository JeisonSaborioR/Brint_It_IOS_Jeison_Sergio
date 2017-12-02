//
//  ShoppingListTableViewCell.swift
//  Bring It!
//
//  Created by Administrador on 10/29/17.
//  Copyright © 2017 tec. All rights reserved.
//  

import UIKit

class ShoppingListTableViewCell: UITableViewCell {

    @IBOutlet weak var dateShoppingListLabel: UILabel!
    @IBOutlet weak var nameShoppingListLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
