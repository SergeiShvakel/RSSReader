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

class RRSModel
{
    var url : String;
    var delegate : RRSModelProtocol? = nil
    
    var rrsNewsRealm : Realm! //
    var newsList: Results<NewsRecord> {
        get {
            return rrsNewsRealm.objects(NewsRecord.self)
        }
    }
    
    init (url: String)
    {
        self.url = url
        self.rrsNewsRealm = nil
        
        rrsNewsRealm = try! Realm();
    }
    
    func loadData()->Void
    {
        var i : Int = 0
        for i in 1...100000
        {
            for var j in 1...100
            {
                var x : Int = 0
                x = i+j
            }
        }
        
        var dataRequest : DataRequest? = nil
        let url : URLConvertible = self.url
        
        dataRequest = Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil)
        dataRequest!.validate().responseData(queue: nil, completionHandler: { responseData in
            switch responseData.result {
                case .success(let value):
                    guard let string = String(data: value, encoding: .utf8) else {
                        break;
                    }
                    //print(string)
                
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
                newsItem.imageURLNews = (elem["enclosure"].element!.attribute(by: "url")?.text)!
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
            
            /*let newsItem = NewsRecord()
            newsItem.titleNews = "Бундестаг поставил под вопрос политику Меркель по мигрантам"
            newsItem.pubDateNews = pubdate.date(from: "Sat, 23 Sep 2017 08:30:00 +0300")!
            
            newsItem.imageURLNews = "https://img.tyt.by/n/reuters/05/d/bundestag_.jpg"
            newsItem.categoryNews = "В мире"
            newsItem.descNews = "&#x3C;img src=\"https://img.tyt.by/thumbnails/n/reuters/05/d/bundestag_.jpg\" width=\"72\" height=\"48\" alt=\"Фото: Reuters\" border=\"0\" align=\"left\" hspace=\"5\" /&#x3E;Бундестаг 22 сентября опубликовал доклад, в котором с юридической точки зрения рассматривается решение канцлера Германии Ангелы Меркель открыть границы страны для мигрантов.&#x3C;br clear=\"all\" /&#x3E;"
            
            arrNews.append(newsItem)
            
            let newsItem2 = NewsRecord()
            
            newsItem2.titleNews = "Вторая новость"
            newsItem2.pubDateNews = pubdate.date(from: "Sat, 23 Sep 2017 10:30:00 +0300")!
            
            newsItem2.imageURLNews = "https://img.tyt.by/n/reuters/05/d/bundestag_.jpg"
            newsItem2.categoryNews = "В мире"
            newsItem2.descNews = "&#x3C;img src=\"https://img.tyt.by/thumbnails/n/reuters/05/d/bundestag_.jpg\" width=\"72\" height=\"48\" alt=\"Фото: Reuters\" border=\"0\" align=\"left\" hspace=\"5\" /&#x3E;Бундестаг 22 сентября опубликовал доклад, в котором с юридической точки зрения рассматривается решение канцлера Германии Ангелы Меркель открыть границы страны для мигрантов.&#x3C;br clear=\"all\" /&#x3E;"
            
            arrNews.append(newsItem2)*/
            
            print (arrNews.count)
            
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
