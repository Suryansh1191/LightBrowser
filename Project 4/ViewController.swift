//
//  ViewController.swift
//  Project 4
//
//  Created by suryansh Bisen on 22/05/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    //var webView: WKWebView!
    @IBOutlet var webView: WKWebView!
    var progreView: UIProgressView!
    var websites = ["www.google.com", "amazon.com" , "apple.com"]
    
//    override func loadView() {
//        webView = WKWebView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addwebsite))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progreView = UIProgressView(progressViewStyle: .default)
        progreView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progreView)
        
        
        toolbarItems = [progressButton, spacer , refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        title = websites[0]
    }
    
    @objc func addwebsite() {
        let ac = UIAlertController(title: "Add Website", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancle", style: .default))
        let submitAction = UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] _ in
            guard let answers = ac?.textFields?[0].text else { return }
            self?.websites.insert(answers, at: 0)
            let urll = URL(string: "https://" + answers)
            self?.webView.load(URLRequest(url: urll!))
            self?.title = answers
        }
                
        ac.addAction(submitAction)
        present(ac, animated: true)
        
        
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open Page...", message: nil, preferredStyle: .actionSheet)
        for website in websites{
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancle", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
        
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
        title = action.title
    }

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = WKWebView().title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progreView.progress = Float(webView.estimatedProgress)
        }
    }
    
}

