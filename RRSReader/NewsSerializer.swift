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
            
            var strTemp: String = elem["description"].element!.text
            
            let findSubstr: ((String, String) -> Int) = {stringin,substring in
                
                var ifind : Int = -1
                var i = 0;
                
                while (i < stringin.count)
                {
                    var bFind = false, bExit = false
                    for j in 0...substring.count-1
                    {
                        let index1 = stringin.index(stringin.startIndex, offsetBy: i)
                        let index2 = substring.index(substring.startIndex, offsetBy: j)
                        
                        if stringin[index1] != substring[index2] {
                            bExit = true
                            break
                        }
                        else{
                            i += 1
                            bFind = true
                        }
                    }
                    if !bExit {
                        ifind = i-substring.count
                        break
                    }
                    else{
                        i = i + (bFind ? 0 : 1)
                    }
                }
                return ifind;
            }
            
            let leftTempl = "/>", rightTempl = "<br"
            
            var nFindInd = findSubstr(strTemp, leftTempl)
            if nFindInd != -1 {
                
                let leftIndex =  strTemp.index(strTemp.startIndex, offsetBy: nFindInd+leftTempl.count)
                strTemp = String (strTemp[leftIndex..<strTemp.endIndex])
                
                nFindInd = findSubstr(strTemp, rightTempl)
                if nFindInd != -1 {
                    let rightIndex =  strTemp.index(strTemp.startIndex, offsetBy: nFindInd)
                    strTemp = String (strTemp[strTemp.startIndex..<rightIndex])
                }
                //print (strTemp)
                
                newsItem.descNews = strTemp;
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

