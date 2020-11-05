//
//  DataManager.swift
//  RSSNewsTask
//
//  Created by Геннадий Махмудов on 02.11.2020.
//

import Foundation
import AlamofireRSSParser

class DataManager {
    
    private var networkClient: NetworkClient?
    private weak var delegate: UpdateDelegate!
    
    private var items = [RSSItem]()
    private var previousSources = [String]()
    private var currentURL = "empty"
    
    init(networkClient: NetworkClient = NetworkClient()){
        self.networkClient = networkClient
    }
    
    final func chooseNewSource(from url: String){
        if url.hasPrefix("http") {
            currentURL = url
            if !previousSources.contains(url) {
                previousSources.append(url)
            }
            self.networkClient?.parseRSS(from: url, completion: {  (results) in
                self.items = results
                self.delegate.didUpdate(sender: self)
            })
        }
    }
    
    final func setUpdateDelegate(delegate: UpdateDelegate){
        self.delegate = delegate
    }
    
    final func selectFromPrevious() -> [String]{
        return previousSources
    }
    
    final func numberOfItems() -> Int {
        return items.count
    }
    final func getCurrentURL() -> String {
        return currentURL
    }
    final func getItems() -> [RSSItem] {
        return items
    }
    
}

protocol UpdateDelegate: class {
    func didUpdate(sender: DataManager)
}

