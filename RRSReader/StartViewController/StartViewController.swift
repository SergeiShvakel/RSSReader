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
    let model : RSSModel
    
    init (_ model : RSSModel)
    {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        model = RSSModel(url: "");
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let dimAlphaRedColor =  UIColor.white.withAlphaComponent(0.7)
        self.view.backgroundColor =  dimAlphaRedColor
        
        let completeHandler: ()->Void = {
            // debug
            print ("StartViewController.viewDidLoad: dismiss")
            
            self.dismiss(animated: true, completion: nil)
        }
        
        let queue = DispatchQueue.global(qos: .utility)
        
        let loadingDataDispItem = DispatchWorkItem(){
            self.model.loadData(completionHandler: completeHandler)
        }
        loadingDataDispItem.notify(queue: DispatchQueue.main)
        {
            
        }
        queue.async(execute: loadingDataDispItem)
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
