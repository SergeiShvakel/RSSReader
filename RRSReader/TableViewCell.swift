//
//  TableViewCell.swift
//  RRSReader
//
//  Created by Сергей Швакель on 23.09.17.
//  Copyright © 2017 Сергей Швакель. All rights reserved.
//

import UIKit
import Alamofire

class TableViewCell: UITableViewCell {

    @IBOutlet var titleNews: UILabel!
    @IBOutlet var categoryNews: UILabel!
    @IBOutlet var dateNews: UILabel!
    @IBOutlet var imageNews: UIImageView!
    
    var request: Alamofire.DataRequest?
    var isRequesting: Bool = false
    
    class var reuseIdentifier: String {
        get {
            return "newsCell"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if imageNews != nil {
            imageNews.layer.cornerRadius = 8.0
            imageNews.clipsToBounds = true
        }
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
