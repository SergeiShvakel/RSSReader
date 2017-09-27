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
    
    dynamic var titleNews: String = ""      // <title> - Title
    dynamic var pubDateNews: Date = Date()  // <pubDate> Sat, 16 Sep 2017 16:38:00 +0300 - Date of public
    dynamic var imageURLNews: String = ""   // <enclosure url=> - Picture
    dynamic var categoryNews: String = ""   // <category> - Category
    dynamic var descNews: String = ""       // <description> - More description

}
