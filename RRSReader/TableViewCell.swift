//
//  TableViewCell.swift
//  RRSReader
//
//  Created by Сергей Швакель on 23.09.17.
//  Copyright © 2017 Сергей Швакель. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var categoryNews: UILabel!
    @IBOutlet weak var dateNews: UILabel!
    @IBOutlet weak var imageNews: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}