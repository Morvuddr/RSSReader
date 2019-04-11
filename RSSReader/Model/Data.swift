//
//  Data.swift
//  RSSReader
//
//  Created by Игорь Бопп on 09/04/2019.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

class Data {
    
    static var newsItems: [NewsItem]?
    static var filteredNewsItems: [NewsItem]?
    // Using set for categories because each category must be unique
    static var categories: Set<String>?
    static var currentFilter = "Все"
    
    // Variable to prevent creating a large number of threads when a user uses pull-to-refresh many times in a row.
    static var isDownloading = false
    
    // Download data using url in the background thread
    static func downloadData(completion: @escaping () -> ()){
        
        guard isDownloading == false else {
            return
        }
        
        isDownloading = true
        
        DispatchQueue.global(qos: .userInteractive).async{
            
            let newsParser = NewsParser().initWithURL("https://www.vesti.ru/vesti.rss")
            
            self.newsItems = newsParser.getNews()
            self.categories = newsParser.getCategories()
            
            // If a filter is selected, the user will see that the data is updated only for a specific filter.
            if self.currentFilter == "Все"{
                self.filteredNewsItems = self.newsItems
            } else {
                self.filteredNewsItems = self.newsItems?.filter(){
                    $0.category == self.currentFilter
                }
            }
            
            DispatchQueue.main.async {
                
                completion()
                
            }
            
        }
        
    }
    
}
