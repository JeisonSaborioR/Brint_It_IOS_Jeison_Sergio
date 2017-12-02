//
//  ProductTableViewCell.swift
//  Bring It!
//
//  Created by Administrador on 11/1/17.
//  Copyright © 2017 tec. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    
    @IBOutlet weak var priceProductLabel: UILabel!
    @IBOutlet weak var quantityProductLabel: UILabel!
    @IBOutlet weak var nameProductLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
