//
//  XMLParser.swift
//  RSSReader
//
//  Created by Игорь Бопп on 05/04/2019.
//  Copyright © 2019 Igor. All rights reserved.
//

import Foundation

class NewsParser: NSObject, XMLParserDelegate {
    
    private var rssItems: [RSSItem] = []
    private var currentElement: String = ""
    private var currentTitle: String = ""{
        didSet{
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentCategory: String = "" {
        didSet{
            currentCategory = currentCategory.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate: String = ""{
        didSet{
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: (([RSSItem]) -> Void)?
    
    func parseNews(url: String, completionHandler: (([RSSItem]) -> Void)?){
        
        self.parserCompletionHandler = completionHandler
        
        let parser = XMLParser(contentsOf: URL(string: url)!)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
        
    }
    
    // MARK: - XML Parser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentPubDate = ""
            currentCategory = ""
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
            let rssItem = RSSItem(title: currentTitle, pubDate: currentPubDate, category: currentCategory)
            rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
}
