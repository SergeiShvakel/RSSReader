//
//  RRSModel.swift
//  RRSReader
//
//  Created by Сергей Швакель on 16.09.17.
//  Copyright © 2017 Сергей Швакель. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import SWXMLHash

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
        dataRequest!.validate().responseData(queue: nil, completionHandler: { responseData in            
           switch responseData.result {
                case .success(let value):
                    guard let string = String(data: value, encoding: .utf8) else {
                        break;
                    }
                    print(string)
                
                case .failure(let error):
                    print(error)
            }
            
            let pubdate : DateFormatter = DateFormatter();
            pubdate.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZ"
            
            let string = String(data: responseData.result.value!, encoding: .utf8)
            
            var xml = SWXMLHash.parse(string!)
            print(xml["rss"]["channel"]["title"].element?.text)
            
            var arrNews : [NewsRecord] = []
            
            for elem in xml["rss"]["channel"]["item"].all
            {
                let newsItem = NewsRecord()
                
                newsItem.titleNews = elem["title"].element!.text
                newsItem.pubDateNews = pubdate.date(from: elem["pubDate"].element!.text)!
                newsItem.categoryNews = elem["category"].element!.text
                
                if let xmlElem : XMLElement = elem["enclosure"].element {
                    newsItem.imageURLNews = (xmlElem.attribute(by: "url")?.text)!
                }
                
                newsItem.descNews = elem["description"].element!.text
                
                arrNews.append(newsItem)
            }
            
            // Дополнительное изменение
            // Открываем соединение
            var rrsNewsRealm : Realm! //
            rrsNewsRealm = try! Realm()
            
            try! rrsNewsRealm.write({()->Void in
                rrsNewsRealm.deleteAll()
            })
            
            //print (arrNews.count)
            
            // добавляем новую запись
            try! rrsNewsRealm.write({()->Void in
                rrsNewsRealm.add(arrNews)
            })
            
            if (self.delegate != nil){
                self.delegate?.loadingDataDidFinish(model: self)
            }
        }
        )
        
        return
    }
}
