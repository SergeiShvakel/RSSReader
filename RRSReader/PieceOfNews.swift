//
//  PieceOfNews.swift
//  RRSReader
//
//  Created by Сергей Швакель on 16.09.17.
//  Copyright © 2017 Сергей Швакель. All rights reserved.
//

import Foundation
/*
    Структура новости из RRS
*/

struct PieceOfNews
{
    var title: String = ""          // <title>
    var pubDate: Date               // <pubDate> Sat, 16 Sep 2017 16:38:00 +0300
    var imageURL: String            // <enclosure url=>
    var category: String            // <category>
    var description: String         // <description>
}
