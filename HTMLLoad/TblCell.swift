//
//  TblCell.swift
//  HTMLLoad
//
//  Created by mac-00017 on 20/07/22.
//

import UIKit
import WebKit

protocol updateHeightDelegete {
    func updateHeight(height:CGFloat, cell: UITableViewCell)
}

class TblCell: UITableViewCell,WKNavigationDelegate {

    @IBOutlet weak var wkWebView: WKWebView!
    var delegete: updateHeightDelegete?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let script = """
                            var script = document.createElement('script');
                            script.src = 'https://platform.instagram.com/en_US/embeds.js';
                            document.getElementsByTagName('head')[0].appendChild(script);
                    """
        
        let userScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        wkWebView.navigationDelegate = self
        wkWebView.configuration.userContentController.addUserScript(userScript)
    }
    
    func loadWebView(_ htmlContent: String ,baseURL: URL) {
        
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY>"
        let htmlEnd = "</BODY></HTML>"
        let html = "\(htmlStart)\(htmlContent)\(htmlEnd)"
        
        DispatchQueue.main.async {
            self.wkWebView.loadHTMLString(html, baseURL: baseURL)
        }
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.delegete?.updateHeight(height: webView.scrollView.contentSize.height, cell: self)
    }
}
