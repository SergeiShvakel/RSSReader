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
    let url: String
    
    var rrsNewsRealm : Realm! //
    var newsList: Results<NewsRecord> {
        get {
            return rrsNewsRealm.objects(NewsRecord.self)
        }
    }
    // dictionary of id -> Image
    var images : [Int:UIImage] = [:]
    
    init (url: String)
    {
        self.url = url
        self.rrsNewsRealm = try! Realm();
        
        /*let messages = [
            Message(user: "Achilles", text: "Hello? Hello?"),
            Message(user: "Achilles", text: "How do you turn this thing on?"),
            
            Message(user: "Tortoise", text: "I'm not quite sure, myself."),
            
            Message(user: "Achilles", text: "Oh, Mr. T! What a nice surprise."),
            Message(user: "Achilles", text: "I'm just trying out our dear friend the Crab's new message-transmission device."),
            Message(user: "Achilles", text: "It can decode and display any kind of message, you know."),
            
            Message(user: "Tortoise", text: "Yes, I dropped by Mr. Crab's house earlier and picked up the companion device."),
            Message(user: "Tortoise", text: "I'm quite excited to try it out – I have a specially-encoded message for just this occasion. Here it comes...")
        ]*/
        /*let grouped = groupByUser(messages)
        grouped.forEach {
            print("")
            $0.forEach {
                print($0, terminator: "\n")
            }
        }*/
        
        //pubDateNews
        
    }
    
    func clearData()->Void{
        images.removeAll()
    }
    
    func loadData(completionHandler: @escaping ()->Void)->Void
    {
        // debug
        print ("RSSModel.loadData: start")
        
        let url : URLConvertible = self.url
        
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseNewsArray(queue: DispatchQueue.global(qos: .utility))
            {
                responseData in
                switch responseData.result {
                    case .success(let value):
                    
                        // Open Realm database connection
                        var rrsNewsRealm : Realm! //
                        rrsNewsRealm = try! Realm()
                    
                        /*try! rrsNewsRealm.write({()->Void in
                            rrsNewsRealm.deleteAll()
                        })*/
                        
                        // Set of NewsRecord
                        var newsList: Results<NewsRecord> {
                            get {
                                return rrsNewsRealm.objects(NewsRecord.self)
                            }
                        }
                        
                        //
                        var nMaxNumber: Int = newsList.count
                        var lastPubDateNews: Date = (nMaxNumber > 0 ? newsList[nMaxNumber-1].pubDateNews : Date(timeIntervalSince1970: 0))
                        
                        for i in (0...value.count-1).reversed(){
                            
                            if value[i].pubDateNews > lastPubDateNews {
                                
                                lastPubDateNews = value[i].pubDateNews
                                nMaxNumber += 1
                                value[i].id = nMaxNumber
                                
                                // Add new records
                                try! rrsNewsRealm.write({()->Void in
                                    rrsNewsRealm.add(value[i])
                                })
                            }
                        }
                        DispatchQueue.main.async(execute:  completionHandler)
                    
                case .failure(_):
                    DispatchQueue.main.async(execute:  completionHandler)
                    return
                }
                
                // debug
                print ("RSSModel.loadData.responseNewsArray: exit")
            }
        
        // debug
        print ("RSSModel.loadData: exit")
        
        return
    }
    
    func getCountNewsToShow() -> Int{
        return 0
    }
    
    func getImageByIndex (_ index : IndexPath) -> UIImage?
    {
        guard index.row >= 0 && index.row < newsList.count else {
            return nil
        }
        let newsOne = newsList[ newsList.count - index.row - 1 ]
        
        if let image = images[newsOne.id] {
            return image
        }
        
        return nil
    }
    
    /*typealias User = String;
    
    struct Message {
        let user: User
        let text: String
    }*/
    
    /*func groupByUser(_ messages: [Message]) -> [[Message]] {
        guard let firstMessage = messages.first, messages.count > 1 else {
            return [messages]
        }
        
        let sameUserTest: (Message) -> Bool = {
            $0.user == firstMessage.user
        }
        let firstGroup = Array(messages.prefix(while: sameUserTest))
        let rest = Array(messages.drop(while: sameUserTest))
        if rest.count == 0  {
            return [Array(firstGroup)]
        }
        
        var Group = groupByUser(Array(rest))
        var bFind = false
        
        for i in 0...Group.count-1
        {
            if Group[i][0].user == firstGroup[0].user {
                Group[i] = Group[i] + firstGroup
                bFind = true
                break
            }
        }
        if !bFind {
            Group = Group + [Array(firstGroup)]
        }
    
        return Group;
    }*/
    
}
