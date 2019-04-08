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
    private var filteredRssItems: [RSSItem]?
    private var categories: [String]?
    private var currentFilter = "Все"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNewsTableView()
        fetchData()
    }
    
    private func fetchData(){
        
        DispatchQueue.global(qos: .userInteractive).async{
            
            let newsParser = NewsParser().initWithURL("https://www.vesti.ru/vesti.rss")
            
            self.rssItems = newsParser.getNews()
            self.categories = newsParser.getCategories()
            
            if self.currentFilter == "Все"{
                self.filteredRssItems = self.rssItems
            } else {
                self.filteredRssItems = self.rssItems?.filter(){
                    $0.category == self.currentFilter
                }
            }
            print(Thread.isMainThread)
            DispatchQueue.main.async {
                self.newsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                print(Thread.isMainThread)
            }
        }
        

        
        
    }
    
    func configureNewsTableView () {
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.estimatedRowHeight = 100
        
        // Add the refresh control to your UIScrollView object.
        newsTableView.refreshControl = UIRefreshControl()
        newsTableView.refreshControl?.addTarget(self,
                                                action: #selector(handleRefreshControl),
                                                for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        
        // Update content
        
        self.fetchData()
        
        // Dismiss the refresh control.
        DispatchQueue.main.async {
            self.newsTableView.refreshControl?.endRefreshing()
        }
        
    }
    
    @IBAction func filterNews(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Текущий фильтр: \(currentFilter)", message: nil, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "Все", style: .default) { (action) in
            self.filteredRssItems = self.rssItems
            self.currentFilter = "Все"
            self.newsTableView.reloadData()
        }
        
        alert.addAction(action)
        
        for category in categories! {
            let action = UIAlertAction(title: category, style: .default) { (action) in
                self.filteredRssItems = self.rssItems?.filter(){
                    $0.category == category
                }
                self.currentFilter = category
                self.newsTableView.reloadData()
            }

            alert.addAction(action)

        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let filteredRssItems = filteredRssItems else{
            
            return 0
            
        }
        
        return filteredRssItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as! NewsTableViewCell
        
        if let item = filteredRssItems?[indexPath.row]{
            cell.item = item
        }
        
        return cell
    }
    
    
}
