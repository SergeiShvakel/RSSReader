//
//  RSSModel.swift
//  RRSReader
//
//  Created by Сергей Швакель on 16.09.17.
//  Copyright © 2017 Сергей Швакель. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class RSSModel
{
    let url : String
    
    var rrsNewsRealm : Realm! //
    var newsList: Results<NewsRecord> {
        get {
            return rrsNewsRealm.objects(NewsRecord.self)
        }
    }
    
    var images : [(IndexPath, UIImage?)] = []
    
    init (url: String)
    {
        self.url = url
        self.rrsNewsRealm = try! Realm();
    }
    
    func clearData()->Void{
        images.removeAll()
    }
    
    func loadData()->Void
    {
        let url : URLConvertible = self.url
        
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseNewsArray(queue: nil)
            {
                responseData in
                switch responseData.result {
                    case .success(let value):
                    
                        // Open Realm database connection
                        var rrsNewsRealm : Realm! //
                        rrsNewsRealm = try! Realm()
                    
                        try! rrsNewsRealm.write({()->Void in
                            rrsNewsRealm.deleteAll()
                        })
                    
                        //print (value.count)
                    
                        // Add new records
                        try! rrsNewsRealm.write({()->Void in
                            rrsNewsRealm.add(value)
                        })
                    
                case .failure(_):
                    return
                }
            }
        
        return
    }
    
    func getImageByIndex (_ index : IndexPath) -> UIImage?
    {
        for image in images
        {
            if (image.0 == index){
                return  image.1
            }
        }
        return nil
    }
}
