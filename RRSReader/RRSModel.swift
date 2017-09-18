//
//  RRSModel.swift
//  RRSReader
//
//  Created by Сергей Швакель on 16.09.17.
//  Copyright © 2017 Сергей Швакель. All rights reserved.
//

import Foundation
import Alamofire

class RRSModel
{
    var url : String;
    var delegate : RRSModelProtocol? = nil
    
    init (url: String)
    {
        self.url = url
    }
    
    func loadData()->Void
    {
        var i : Int = 0
        for i in 1...100000
        {
            for var j in 1...1000
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
                    print(string)
                
                case .failure(let error):
                    print(error)
            }
            
            if (self.delegate != nil){
                self.delegate?.loadingDataDidFinish(model: self)
            }
        }
        )
        
        return
    }
}
