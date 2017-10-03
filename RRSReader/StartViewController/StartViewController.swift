//
//  StartViewController.swift
//  RRSReader
//
//  Created by Сергей Швакель on 16.09.17.
//  Copyright © 2017 Сергей Швакель. All rights reserved.
//

import UIKit
import RealmSwift

class StartViewController: UIViewController
{
    var model : RSSModel?
    
    init (_ model : RSSModel)
    {
        super.init(nibName: nil, bundle: nil)
        
        self.model = model
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        let loadingDataDispItem = DispatchWorkItem(){
            self.model?.loadData()
        }
        
        queue.async(execute: loadingDataDispItem)
        
        loadingDataDispItem.notify(queue: DispatchQueue.main)
        {
            self.dismiss(animated: true, completion: nil)
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
