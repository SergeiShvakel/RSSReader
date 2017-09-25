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
    
    var index : IndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var app : AppDelegate? = nil
        app = UIApplication.shared.delegate as! AppDelegate?
        
        let oneNews = app?.model?.newsList[index.row]
        
        print (oneNews?.titleNews)
        
        let dateFormat : DateFormatter = DateFormatter()
        dateFormat.dateFormat = "dd MMM yyyy HH:mm:ss"
        
        dateLabel.text = dateFormat.string(from: (oneNews?.pubDateNews)!)
        titleLabel.text = oneNews?.titleNews
        descLabel.text = oneNews?.descNews
        
        print (app?.model?.images.count)
        
        for image in (app?.model?.images)!
        {
            if (image.0 == index)
            {
                imageNews.image = image.1
                break
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
