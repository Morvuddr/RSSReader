//
//  NewsItemViewController.swift
//  RSSReader
//
//  Created by Игорь Бопп on 08/04/2019.
//  Copyright © 2019 Igor. All rights reserved.
//

import UIKit

class NewsItemViewController: UIViewController {
    
    @IBOutlet weak var newsItemImage: UIImageView!
    @IBOutlet weak var newsItemTitle: UILabel!
    @IBOutlet weak var newsItemDescription: UILabel!
    
    var newsItem: NewsItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage(url: newsItem!.img)
        newsItemTitle.text = newsItem?.title
        newsItemDescription.text = newsItem?.description
        
    }
    
    func loadImage(url: String){
        DispatchQueue.global(qos: .userInteractive).async{
            let url = URL(string: url)
            let data = NSData(contentsOf:url! as URL)
            let image = UIImage(data:data! as Foundation.Data)
            
            DispatchQueue.main.async {
                self.newsItemImage.alpha = 0
                self.newsItemImage.image = image
                UIView.animate(withDuration: 1) {
                    self.newsItemImage.alpha = 1
                }
                
            }
        }
        
    }

}
