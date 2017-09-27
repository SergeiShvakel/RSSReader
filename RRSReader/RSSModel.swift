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
    var url : String;
    var delegate : RSSModelProtocol? = nil
    
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
        self.rrsNewsRealm = nil
        
        rrsNewsRealm = try! Realm();
    }
    
    func loadData()->Void
    {
        var dataRequest : DataRequest? = nil
        let url : URLConvertible = self.url
        
        dataRequest = Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil)
        dataRequest!
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
                    
                case .failure(let error):
                    return
                }
            
            if (self.delegate != nil){
                self.delegate?.loadingDataDidFinish(model: self)
            }
        }
        
        return
    }
}
