//
//  XMLParser.swift
//  RSSReader
//
//  Created by Игорь Бопп on 05/04/2019.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

class NewsParser: NSObject {
    
    private var newsItems: [NewsItem] = []
    // Using set for categories because each category must be unique
    private var categories: Set<String> = []
    private var currentElement: String = ""
    private var currentImage: String = ""
    private var currentTitle: String = ""
    private var currentDescription: String = ""
    private var currentCategory: String = "" {
        didSet{
            currentCategory = currentCategory.trimmingCharacters(in: .whitespacesAndNewlines)
            if currentCategory != "" {
                categories.insert(currentCategory)
            }
        }
    }
    private var currentPubDate: String = ""{
        didSet{
            if currentPubDate != ""{
                currentPubDate = currentPubDate.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
    }
    
    // initilise parser
    func initWithURL(_ url :String) -> NewsParser {
        parseNews(url: url)
        return self
    }
    
    func parseNews(url: String){
        
        let parser = XMLParser(contentsOf: URL(string: url)!)!
        parser.delegate = self
        parser.parse()
        
    }
    
    func getNews() -> [NewsItem] {
        return newsItems
    }
    
    func getCategories() -> Set<String>{
        return categories
    }
    
}

extension NewsParser: XMLParserDelegate {
    
    // MARK: - XML Parser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentPubDate = ""
            currentCategory = ""
            currentDescription = ""
        } else if currentElement == "enclosure" {
            if let urlString = attributeDict["url"] {
                currentImage = urlString
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "pubDate":
            currentPubDate += string
        case "category":
            currentCategory += string
        case "yandex:full-text":
            currentDescription += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            var newsItem = NewsItem(title: currentTitle, pubDate: currentPubDate, category: currentCategory, img: currentImage, description: currentDescription)
            newsItem.trimmingTitleAndDescription()
            newsItems.append(newsItem)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
}
