//
//  ViewController.swift
//  iOSWebViewAppWithMax
//

import UIKit
import WebKit
import AppLovinSDK

class ViewController: UIViewController, WKScriptMessageHandler, MARewardedAdDelegate {
    
    var webView: WKWebView!
    var rewardedAd: MARewardedAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "loadButtonClicked")
        contentController.add(self, name: "showButtonClicked")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        webView = WKWebView(frame: self.view.frame, configuration: config)
        self.view.addSubview(webView)
        
        let htmlString = """
        <html>
            <head>
                <title>sample</title>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <script>
                    function loadButtonClicked() {
                        window.webkit.messageHandlers.loadButtonClicked.postMessage("load button was clicked");
                    }
                    function showButtonClicked() {
                        window.webkit.messageHandlers.showButtonClicked.postMessage("show button was clicked");
                    }
                </script>
            </head>
            <body>
                <h1>sample</h1>
                <button id="loadButton" type="button" onclick="loadButtonClicked()">load</button>
                <button id="showButton" type="button" onclick="showButtonClicked()" disabled>show</button>
            </body>
        </html>
        """
        
        webView.loadHTMLString(htmlString, baseURL: nil)
        
        rewardedAd = MARewardedAd.shared(withAdUnitIdentifier: "YOUR_UNIT_ID")
        rewardedAd.delegate = self
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "loadButtonClicked" {
            load()
        }
        if message.name == "showButtonClicked" {
            show()
        }
    }
    
    func load() {
        rewardedAd.load()
    }
    
    func show() {
        if rewardedAd.isReady {
            rewardedAd.show()
        }
    }
    
    // MARK: MAAdDelegate Protocol
    func didLoad(_ ad: MAAd) {
        print("did load ad")
        let javascript = "document.getElementById('showButton').disabled = false;"
        webView.evaluateJavaScript(javascript, completionHandler: nil)
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        print("did fail to load ad")
    }
    
    func didDisplay(_ ad: MAAd) {
        print("did display")
    }
    
    func didClick(_ ad: MAAd) {
        print("did click")
    }
    
    func didHide(_ ad: MAAd){
        print("did hide")
        let javascript = "document.getElementById('showButton').disabled = true;"
        webView.evaluateJavaScript(javascript, completionHandler: nil)
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        print("did fail to display")
    }
    
    // MARK: MARewardedAdDelegate Protocol
    func didRewardUser(for ad: MAAd, with reward: MAReward) {
        print("did reward user")
    }
    
}

