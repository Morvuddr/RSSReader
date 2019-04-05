//
//  NewsViewController.swift
//  RSSReader
//
//  Created by Игорь Бопп on 05/04/2019.
//  Copyright © 2019 Igor. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    
    private var rssItems: [RSSItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.estimatedRowHeight = 100
        
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    private func fetchData(){
        let newsParser = NewsParser()
        newsParser.parseNews(url: "https://www.vesti.ru/vesti.rss") { (rssItems) in
            self.rssItems = rssItems
            
            OperationQueue.main.addOperation {
                self.newsTableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
    }
    
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let rssItems = rssItems else{
            
            return 0
            
        }

        return rssItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as! NewsTableViewCell
        
        if let item = rssItems?[indexPath.item]{
            cell.item = item
        }
        
        return cell
    }
    
    
}
