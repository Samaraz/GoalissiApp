//
//  BrowserViewController.swift
//  GoalissiApp
//
//  Created by MAC on 05/08/2022.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController,WKNavigationDelegate {
    var playerToSearch : String?
    var delegate: outsideControl?
    var update: outsideControl?
   
    var webView : WKWebView!
    var progressView:UIProgressView!
    let viewController = ViewController()
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        progressView = UIProgressView(progressViewStyle: .default )
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)// Wrap our progressView item so that it can go into our tool bar
        
        toolbarItems = [back,spacer,progressButton,spacer,refresh,forward]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options:.new, context: nil)

        // Do any additional setup after loading the view.
        goOnline()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.playCountDownTimer()
        self.update?.updateUI()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func goOnline(){
        
        let fullName : String = playerToSearch!
        let fullNameArr : [String] = fullName.components(separatedBy: " ")
        let firstName : String
        let lastName : String

        // And then to access the individual words:
        if fullNameArr.count > 1{
            firstName = fullNameArr[0]
            lastName = fullNameArr[1]
        } else{
                 firstName = fullNameArr[0]
                 lastName = ""
        }
        
      
        //print(firstName)
       // print(lastName)
     
        if let url = URL(string:"https://en.wikipedia.org/wiki/\(firstName)_\(lastName )"){
                webView.load(URLRequest(url: url))
                webView.allowsBackForwardNavigationGestures = true
            }
    }
}
