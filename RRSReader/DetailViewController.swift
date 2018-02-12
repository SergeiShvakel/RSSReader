//
//  DetailViewController.swift
//  RRSReader
//
//  Created by Сергей Швакель on 24.09.17.
//  Copyright © 2017 Сергей Швакель. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var imageNews: UIImageView!
    
    var index : IndexPath?
    var model : RSSModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let oneNews = model?.newsList[(model?.newsList.count)! - (index?.row)! - 1]
        {
            let dateFormat : DateFormatter = DateFormatter()
            dateFormat.dateFormat = "dd MMM yyyy HH:mm:ss"
            
            dateLabel.text = dateFormat.string(from: (oneNews.pubDateNews))
            titleLabel.text = oneNews.titleNews
            
            descLabel.text = oneNews.descNews
            
            imageNews.layer.cornerRadius = 8.0
            imageNews.clipsToBounds = true
            
            imageNews.image = model?.getImageByIndex(index!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        descLabel.numberOfLines = 0
        descLabel.sizeToFit()
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
