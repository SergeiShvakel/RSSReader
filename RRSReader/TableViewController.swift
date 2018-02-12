//
//  ViewController.swift
//  RRSReader
//
//  Created by Сергей Швакель on 13.09.17.
//  Copyright © 2017 Сергей Швакель. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UIViewController {
    
    var model : RSSModel?
    
    var nRefreshing: Bool = false
    
    @IBOutlet var tableViewOwn: TableView!

    var tableViewData: TableViewData?
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(didPressRefreshButton))
        
        tableViewData = TableViewData(model_: model!)
        
        // initialize View
        tableViewOwn.dataSource =  tableViewData
        tableViewOwn.delegate = tableViewData
        
        didPressRefreshButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didPressRefreshButton() -> Void{
        
        nRefreshing = true
        
        let startViewController = StartViewController(model!)
        self.present(startViewController, animated: false, completion: nil)
        
        //model?.clearData()
        
        tableViewOwn?.reloadData()
    }
    
}

