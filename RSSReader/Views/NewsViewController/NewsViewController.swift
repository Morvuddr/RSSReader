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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNewsTableView()
        Data.downloadData(){ [unowned self] in
            self.reloadNewsTableView()
        }
    }
    
    func configureNewsTableView () {
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.estimatedRowHeight = 100
        
        // Add the refresh control to UITableView object.
        newsTableView.refreshControl = UIRefreshControl()
        newsTableView.refreshControl?.addTarget(self,
                                                action: #selector(handleRefreshControl),
                                                for: .valueChanged)
    }
    
    func reloadNewsTableView(){
        self.newsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        Data.isDownloading = false
    }
    
    private func refreshData(){
        
        // Update content
        
        Data.downloadData(){ [unowned self] in
            self.reloadNewsTableView()
        }
        
        // Dismiss the refresh control.
        let deadline = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.newsTableView.refreshControl?.endRefreshing()
        }
        
    }
    
    @objc func handleRefreshControl() {
        
        if !newsTableView.isDragging{

            refreshData()
            
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if newsTableView.refreshControl?.isRefreshing == true {

            refreshData()
            
        }
        
    }
    
    @IBAction func filterNews(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Текущий фильтр: \(Data.currentFilter)", message: nil, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "Все", style: .default) { (action) in
            Data.filteredNewsItems = Data.newsItems
            Data.currentFilter = "Все"
            self.newsTableView.reloadData()
        }
        
        alert.addAction(action)
        
        for category in Data.categories! {
            let action = UIAlertAction(title: category, style: .default) { (action) in
                Data.filteredNewsItems = Data.newsItems?.filter(){
                    $0.category == category
                }
                Data.currentFilter = category
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
        
        guard let filteredRssItems = Data.filteredNewsItems else{
            
            newsTableView.separatorColor = UIColor.white
            return 0
            
        }
        
        newsTableView.separatorColor = UIColor.gray
        return filteredRssItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as! NewsTableViewCell
        
        if let item = Data.filteredNewsItems?[indexPath.row]{
            cell.item = item
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Returns the initial view controller on a storyboard
        let storyboard = UIStoryboard(name: String(describing: NewsItemViewController.self), bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! NewsItemViewController
        
        viewController.newsItem = Data.filteredNewsItems?[indexPath.row]
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
