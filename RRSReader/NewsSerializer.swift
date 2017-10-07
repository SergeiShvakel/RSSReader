//
//  NewsSerializer.swift
//  RRSReader
//
//  Created by Сергей Швакель on 26.09.17.
//  Copyright © 2017 Сергей Швакель. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

private let emptyDataStatusCodes: Set<Int> = [204, 205]

extension Alamofire.Request {
    
    public static func serializeResponseNewsArray(response: HTTPURLResponse?, data: Data?, error: Error?) -> Result<[NewsRecord]>
    {
        guard error == nil else { return .failure(error!) }
        
        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success([]) }

        guard let validData = data else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
        }
        
        //  parse validData
        let pubdate : DateFormatter = DateFormatter();
        pubdate.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZ"
        
        let string = String(data: validData, encoding: .utf8)
        
        let xml = SWXMLHash.parse(string!)
        //print(xml["rss"]["channel"]["title"].element?.text)
        
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
            
            let strTemp = elem["description"].element!.text
            
            let leftTempl = "/>", rightTempl = "<br"
            
            let result = strTemp.range(of: leftTempl,
                                    options: NSString.CompareOptions.literal,
                                    range: strTemp.startIndex..<strTemp.endIndex,
                                    locale: nil)
            if (result != nil)
            {
                var text = strTemp.substring(from: strTemp.characters.index((result?.lowerBound)!, offsetBy: leftTempl.characters.count))
                text = text.substring(to: (text.range(of: rightTempl)?.lowerBound)!)
                
                newsItem.descNews = text;
            }
            
            
            
            arrNews.append(newsItem)
        }
        
        return .success(arrNews)
    }
}

extension Alamofire.DataRequest
{
    public static func newsArrayResponseSerializer() -> DataResponseSerializer<[NewsRecord]> {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseNewsArray(response: response, data: data, error: error)
        }
    }
    
    public func responseNewsArray(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<[NewsRecord]>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.newsArrayResponseSerializer(),
            completionHandler: completionHandler
        )
    }
}

