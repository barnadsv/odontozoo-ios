//
//  ImageTableViewCell.swift
//  odontozoo-ios
//
//  Created by Leonardo de Araujo Barnabe on 05/10/17.
//  Copyright © 2017 Leonardo de Araujo Barnabe. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nomeAnimalLabel: UILabel!
    @IBOutlet weak var racaAnimalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
