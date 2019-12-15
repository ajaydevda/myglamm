//
//  CellForTableView.swift
//  MyGlamm
//
//  Created by C711091 on 13/12/19.
//  Copyright © 2019 icici. All rights reserved.
//

import UIKit

class CellForTableView: UITableViewCell {

    @IBOutlet weak var restroImage: UIImageView!
    @IBOutlet weak var restroLabel: UILabel!
    
    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var rating_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    }

