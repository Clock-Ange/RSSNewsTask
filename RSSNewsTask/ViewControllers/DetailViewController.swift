//
//  DetailViewController.swift
//  RSSNewsTask
//
//  Created by Геннадий Махмудов on 03.11.2020.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    private var webView: WKWebView!
    private var newsSetter: NewsSetter!
    
    override func loadView() {
        configureWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setWebViewWithHTML()
    }
    
    final func setNewsSetter(with setter: NewsSetter){
        self.newsSetter = setter
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureWebView(){
        webView = WKWebView()
        view = webView
    }
    
    
    private func setWebViewWithHTML(){
        let html = """
        <html>
        <head>
        <b>\(newsSetter.setNewsTitle())</b>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(newsSetter.setNewsDescription())
        </body>
        <i>\(newsSetter.setNewsDate())</i>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
    
}
