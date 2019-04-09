//
//  NewsTableViewCell.swift
//  RSSReader
//
//  Created by Игорь Бопп on 05/04/2019.
//  Copyright © 2019 Igor. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var item: NewsItem! {
        didSet{
            newsTitle.text = item.title
            dateLabel.text = item.pubDate
        }
    }
    
}

extension UITableViewCell {
    
    class var identifier: String {
        return String(describing: self)
    }
    
}
