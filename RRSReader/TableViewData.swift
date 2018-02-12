//
//  TableViewData.swift
//  RRSReader
//
//  Created by Сергей Швакель on 2/11/18.
//  Copyright © 2018 Сергей Швакель. All rights reserved.
//

import UIKit
import Alamofire

class TableViewData: NSObject, UITableViewDelegate, UITableViewDataSource {

    let model: RSSModel
    let dateFormat : DateFormatter = DateFormatter()
    
    init (model_: RSSModel)
    {
        model = model_
        dateFormat.dateFormat = "dd MMM yyyy"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let num = model.newsList.count
        return num;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier) as! TableViewCell
        
        if cell.isRequesting {
            
            cell.imageNews.image = nil
            cell.request?.cancel()
            
            cell.isRequesting = false
        }
        
        let oneNews = model.newsList[model.newsList.count - indexPath.row - 1]
        
        cell.titleNews?.text    = oneNews.titleNews
        cell.dateNews?.text     = dateFormat.string(from: oneNews.pubDateNews)
        cell.categoryNews?.text = oneNews.categoryNews
        cell.imageNews?.image   = model.getImageByIndex(indexPath)
        
        if (cell.imageNews?.image == nil)
        {
            // Download picture from URL
            let mediaUrl = oneNews.imageURLNews
            
            cell.isRequesting = true
            
            cell.request = Alamofire.request(mediaUrl)
                .response(){
                    response in
                    
                    let image = UIImage(data: response.data!)
                    cell.imageNews!.image = image
                    
                    self.model.images[oneNews.id] = image
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "RSS Tut.by"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height : CGFloat = 150.0;
        
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app : AppDelegate? = UIApplication.shared.delegate as! AppDelegate?
        
        let storyBoard : UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
        
        let detailViewController : DetailViewController? =
            storyBoard!.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        guard (detailViewController != nil) else {
            return
        }
        
        detailViewController?.index = indexPath
        detailViewController?.model = model
        
        app?.navigateViewController?.pushViewController(detailViewController!, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
