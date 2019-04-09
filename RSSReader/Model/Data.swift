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
    static var categories: [String]?
    static var currentFilter = "Все"
    static var isDownloading = false
    
    static func downloadData(completion: @escaping () -> ()){
        
        guard isDownloading == false else {
            return
        }
        
        isDownloading = true
        
        DispatchQueue.global(qos: .userInteractive).async{
            
            let newsParser = NewsParser().initWithURL("https://www.vesti.ru/vesti.rss")
            
            self.newsItems = newsParser.getNews()
            self.categories = newsParser.getCategories()
            
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
