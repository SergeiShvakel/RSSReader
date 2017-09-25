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

    weak var model : RSSModel?
    
    init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, model: RSSModel?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.model = model;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        model = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var app : AppDelegate? = nil
        app = UIApplication.shared.delegate as! AppDelegate?
        
        let num = app?.model?.newsList.count
        
        return num!;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var app : AppDelegate? = nil
        app = UIApplication.shared.delegate as! AppDelegate?
        
        var cell : TableViewCell? = nil
            
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
        
        //print (indexPath.row)
        
        let oneNews = app?.model?.newsList[indexPath.row]
        
        let dateFormat : DateFormatter = DateFormatter()
        dateFormat.dateFormat = "dd MMM yyyy"
        
        cell?.titleNews?.text = oneNews?.titleNews
        cell?.dateNews.text = dateFormat.string(from: (oneNews?.pubDateNews)!)
        cell?.categoryNews.text = oneNews?.categoryNews
        
        var bFind = false
        for image in (app?.model?.images)!
        {
            if (image.0 == indexPath)
            {
                cell?.imageNews!.image = image.1
                bFind = true
                break
            }
        }
        
        if (bFind == false)
        {
            // Загрузка картинки
            if let mediaUrl = (oneNews?.imageURLNews)
            {
                cell?.request = Alamofire.request(mediaUrl)
                    .response(){
                        response in
                        
                        let image = UIImage(data: response.data!)
                        
                        if (cell != nil)
                        {
                            cell?.imageNews!.image = image
                        }
                        app?.model?.images.append((indexPath, image))
                }
            }
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "RSS Tut.by"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height : CGFloat = tableView.rowHeight;
        
        height = 150.0
        
        return height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*let alert : UIAlertController = UIAlertController(title: "My Alert", message: "This is an alert.", preferredStyle: .alert)
        let defaultAction : UIAlertAction = UIAlertAction(title: "Ok", style: .`default`, handler: nil)
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)*/
        
        var app : AppDelegate? = nil
        app = UIApplication.shared.delegate as! AppDelegate?
        
        var detailViewController : DetailViewController? = nil
        
        var storyBoard : UIStoryboard? = nil
        storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        detailViewController = storyBoard!.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        detailViewController?.index = indexPath
        
        app?.navigateViewController?.pushViewController(detailViewController!, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
}

