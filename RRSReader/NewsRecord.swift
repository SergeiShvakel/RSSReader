//
//  NewsRecord.swift
//  RRSReader
//
//  Created by Сергей Швакель on 22.09.17.
//  Copyright © 2017 Сергей Швакель. All rights reserved.
//

import Foundation
import RealmSwift

class NewsRecord : Object {
    
    dynamic var titleNews: String = ""      // <title> - Заголовок
    dynamic var pubDateNews: Date = Date()         // <pubDate> Sat, 16 Sep 2017 16:38:00 +0300 - Дата публикации
    dynamic var imageURLNews: String = ""   // <enclosure url=> - Картинка
    dynamic var categoryNews: String = ""        // <category> - категория
    dynamic var descNews: String = ""            // <description> - более полное описание

}
