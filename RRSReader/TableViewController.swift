//
//  ViewController.swift
//  RRSReader
//
//  Created by Сергей Швакель on 13.09.17.
//  Copyright © 2017 Сергей Швакель. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class TableViewController: UITableViewController {

    var model : RSSModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(didPressRefreshButton))
        
        didPressRefreshButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let num = model?.newsList.count

        return num!;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : TableViewCell?
            
        cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! TableViewCell?
        if (cell == nil)
        {
            cell = TableViewCell.init(style: .default, reuseIdentifier: "newsCell")
        }
        else
        {
            cell?.imageNews.image = nil
            cell?.request?.cancel()
        }
        
        let oneNews = model?.newsList[indexPath.row]
        
        let dateFormat : DateFormatter = DateFormatter()
        dateFormat.dateFormat = "dd MMM yyyy"
        
        cell?.titleNews?.text = oneNews?.titleNews
        cell?.dateNews.text = dateFormat.string(from: (oneNews?.pubDateNews)!)
        cell?.categoryNews.text = oneNews?.categoryNews
        cell?.imageNews?.image = model?.getImageByIndex(indexPath)
        
        if (cell?.imageNews?.image == nil)
        {
            // Download picture from URL
            if let mediaUrl = (oneNews?.imageURLNews)
            {
                cell?.request = Alamofire.request(mediaUrl)
                    .response(){
                        response in
                        
                        let image = UIImage(data: response.data!)
                        cell?.imageNews!.image = image

                        self.model?.images.append((indexPath, image))
                }
            }
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "RSS Tut.by"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height : CGFloat = 150.0;
        
        return height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    
    func didPressRefreshButton() -> Void{
        
        model?.clearData()
        
        let startViewController = StartViewController(model!)
        self.present(startViewController, animated: true, completion: nil)
    }
    
}

