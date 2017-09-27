//
//  StartViewController.swift
//  RRSReader
//
//  Created by Сергей Швакель on 16.09.17.
//  Copyright © 2017 Сергей Швакель. All rights reserved.
//

import UIKit
import RealmSwift

class StartViewController: UIViewController, RSSModelProtocol
{
    var m_loadingThread : Thread?  // Thread for initialyzing model class
    weak var model : RSSModel? = nil
    
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

        model?.delegate = self;
        
        // Start loading data to Model
        m_loadingThread = Thread.init(target: self, selector: #selector(threadParallelProc), object: model)
        m_loadingThread?.start()
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

    /*
        Function of thread for reading data to Model
     */
    @objc func threadParallelProc (argument: Any?) -> Void
    {
        weak var model = argument as! RSSModel?
        
        var exitNow : Bool = false
        let runLoop : RunLoop = RunLoop.current
        
    
        // Add the exitNow BOOL to the thread dictionary.
        var threadDict : NSMutableDictionary? = nil
        threadDict = Thread.current.threadDictionary;
        
        threadDict?.setValue(exitNow, forKey: "ThreadShouldExitNow")
        
        // Loading data - news list
        model?.loadData()
    
        while (!exitNow)
        {
            // Run the run loop but timeout immediately if the input source isn't waiting to fire.
            let date : Date = Date()
            runLoop.run(until: date)
    
            // Check to see if an input source handler changed the exitNow value.
            exitNow = ((threadDict?.value(forKey: "ThreadShouldExitNow")) != nil)
        }
    
        return;
    }
    
    /*
        Method react on event finishing thread
    */
    func aThreadHasFinished ( object : Any? ) -> Void
    {
        var app : AppDelegate? = nil
        app = UIApplication.shared.delegate as! AppDelegate?
        
        self.dismiss(animated: true, completion: nil)
        
        app!.showViewController()
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////
    // Methods of protocol RSSModelProtocol
    
    func loadingDataDidFinish(model: RSSModel?) -> Void
    {
        // Stop thread
        m_loadingThread?.threadDictionary.setValue(true, forKey: "ThreadShouldExitNow")
        
        //var selector : Selector = Selector("aThreadHasFinished")
        
        self.performSelector(onMainThread: #selector(aThreadHasFinished(object:)), with: model, waitUntilDone: false)
    }
    
}
