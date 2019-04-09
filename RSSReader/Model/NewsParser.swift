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
    private var categories: [String] = []
    private var currentElement: String = ""
    private var currentTitle: String = ""
    private var currentImage: String = ""
    private var currentCategory: String = "" {
        didSet{
            currentCategory = currentCategory.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if !categories.contains(currentCategory) && currentCategory != "" {
                categories.append(currentCategory)
            }
        }
    }
    private var currentPubDate: String = ""{
        didSet{
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if currentPubDate != ""{
                currentPubDate.removeLast(3)
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
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
        
    }
    
    func getNews() -> [NewsItem] {
        return newsItems
    }
    
    func getCategories() -> [String]{
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
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            let newsItem = NewsItem(title: currentTitle, pubDate: currentPubDate, category: currentCategory, img: currentImage)
            newsItems.append(newsItem)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
}
