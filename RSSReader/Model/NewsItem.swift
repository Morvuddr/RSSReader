//
//  RSSItem.swift
//  RSSReader
//
//  Created by Игорь Бопп on 05/04/2019.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

struct NewsItem {
    var title: String
    var pubDate: String
    var category: String
    var img: String
    var description: String
    
    func createDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZ"
        dateFormatter.timeZone = TimeZone.current
        guard let date = dateFormatter.date(from: pubDate) else{
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: date)
    }
}
