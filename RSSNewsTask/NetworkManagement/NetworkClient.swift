//
//  NetworkClient.swift
//  RSSNewsTask
//
//  Created by Геннадий Махмудов on 02.11.2020.
//

import Foundation
import Alamofire
import AlamofireRSSParser


class NetworkClient {
    
    final func parseRSS(from url: String, completion: @escaping ([RSSItem]) -> Void){
        AF.request(url).responseRSS() { (response) -> Void in
            if let feed: RSSFeed = response.value {
                DispatchQueue.main.async {
                    completion(feed.items)
                }
            }
        }
        
    }
}
