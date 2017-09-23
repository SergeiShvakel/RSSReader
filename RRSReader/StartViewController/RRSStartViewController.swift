//
//  RRSStartViewController.swift
//  RRSReader
//
//  Created by Сергей Швакель on 16.09.17.
//  Copyright © 2017 Сергей Швакель. All rights reserved.
//

import UIKit
import RealmSwift

class RRSStartViewController: UIViewController, RRSModelProtocol
{
    var m_loadingThread : Thread?  // Отдельный поток для инициализации класса модели
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var app : AppDelegate? = nil
        app = UIApplication.shared.delegate as! AppDelegate?
        
        app?.model?.delegate = self;
        
        m_loadingThread = Thread.init(target: self, selector: #selector(threadParallelProc), object: nil)
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
        Функция потока чтения данных в модель
     */
    @objc func threadParallelProc () -> Void
    {
        var app : AppDelegate? = nil
        app = UIApplication.shared.delegate as! AppDelegate?
        
        var exitNow : Bool = false
        let runLoop : RunLoop = RunLoop.current
        
    
        // Add the exitNow BOOL to the thread dictionary.
        var threadDict : NSMutableDictionary? = nil
        threadDict = Thread.current.threadDictionary;
        
        threadDict?.setValue(exitNow, forKey: "ThreadShouldExitNow")
        
        // Загрузка данных - список новостей
        app?.model?.loadData()
    
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
        Метод реагирует на событие остановки параллельного потока
    */
    func aThreadHasFinished ( object : Any? ) -> Void
    {
        var app : AppDelegate? = nil
        app = UIApplication.shared.delegate as! AppDelegate?
    
        let model : RRSModel? = object as! RRSModel?
    
        self.dismiss(animated: false, completion: nil)
        app!.showViewController()
        
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////
    // Методы протокола RRSModelProtocol
    
    func loadingDataDidFinish(model: RRSModel?) -> Void
    {
        // Останавливаем поток
        m_loadingThread?.threadDictionary.setValue(true, forKey: "ThreadShouldExitNow")
        
        //var selector : Selector = Selector("aThreadHasFinished")
        
        self.performSelector(onMainThread: #selector(aThreadHasFinished(object:)), with: model, waitUntilDone: false)
        
        //[self performSelectorOnMainThread:@selector(aThreadHasFinished:) withObject:model waitUntilDone:NO];
    }
    
}
