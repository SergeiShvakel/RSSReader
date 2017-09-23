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

class ViewController: UITableViewController {

    weak var model : RRSModel?
    
    init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, model: RRSModel?) {
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
        
        //print (indexPath.row)
        
        let oneNews = app?.model?.newsList[indexPath.row]
        
        let dateFormat : DateFormatter = DateFormatter()
        dateFormat.dateFormat = "dd MMM yyyy HH:mm"
        
        cell?.titleNews?.text = oneNews?.titleNews
        cell?.dateNews.text = dateFormat.string(from: (oneNews?.pubDateNews)!)
        cell?.categoryNews.text = oneNews?.categoryNews
        
        if ((cell?.imageNews!.image) == nil)
        {
            // Загрузка картинки
            
            if let mediaUrl = (oneNews?.imageURLNews)
            {
                Alamofire.request(mediaUrl).response(){
                    response in
                    let image = UIImage(data: (response.data! as NSData) as Data)
                    cell?.imageNews!.image = image
                }
            }
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "RRS Tut.by"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height : CGFloat = tableView.rowHeight;
        
        height = 150.0
        
        return height
    }
}

