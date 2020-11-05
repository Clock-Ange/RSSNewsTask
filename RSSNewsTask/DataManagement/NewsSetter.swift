//
//  NewsSetter.swift
//  RSSNewsTask
//
//  Created by Геннадий Махмудов on 04.11.2020.
//

import Foundation
import AlamofireRSSParser

class NewsSetter {
    
    private var item: RSSItem?
    
    init(item: RSSItem){
        self.item = item
    }
    
    final func setNewsTitle() -> String {
        return item?.title ?? ""
    }
    final func setNewsDescription() -> String {
        return item?.itemDescription ?? ""
    }
    final func setNewsDate() -> Date {
        return item?.pubDate ?? Date()
    }
}
