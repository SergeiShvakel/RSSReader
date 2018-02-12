//
//  NewsRecord.swift
//  RRSReader
//
//  Created by Сергей Швакель on 22.09.17.
//  Copyright © 2017 Сергей Швакель. All rights reserved.
//

import Foundation
import RealmSwift

public class NewsRecord : Object {
    
    @objc dynamic var id = 0               // primaryKey
    
    @objc dynamic var titleNews: String = ""      // <title> - Title
    @objc dynamic var pubDateNews: Date = Date()  // <pubDate> Sat, 16 Sep 2017 16:38:00 +0300 - Date of public
    @objc dynamic var imageURLNews: String = ""   // <enclosure url=> - Picture
    @objc dynamic var categoryNews: String = ""   // <category> - Category
    @objc dynamic var descNews: String = ""       // <description> - More description
    
    public override static func primaryKey() -> String? {
        return "id"
    }
}
