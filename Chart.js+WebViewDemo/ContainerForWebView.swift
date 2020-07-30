//
//  ViewController.swift
//  Chart.js+WebViewDemo
//
//  Created by 入江真礼 on 2020/07/30.
//  Copyright © 2020 入江真礼. All rights reserved.
//

import UIKit
import WebKit

class ContainerForWebView: UIViewController {

    private var wkWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWKWebView()
        loadLocalHTML()
    }
}

extension ContainerForWebView {

    // MARK: - Setup WKWebView
    private func setupWKWebView() {

        let deviceBound = UIScreen.main.bounds
        //containerの中でWebView以外のすスペースを作る場合は下記の通り
        let topSpace = 50
        let webConfig = WKWebViewConfiguration()
        wkWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: Int(deviceBound.size.width), height: Int(deviceBound.size.width)-topSpace), configuration: webConfig)

        wkWebView.navigationDelegate = self
        view = wkWebView
    }

    // MARK: - Load Web Page
    private func loadLocalHTML() {
        guard let path: String = Bundle.main.path(forResource: "chartSample", ofType: "html") else { return }
        let localHTMLUrl = URL(fileURLWithPath: path, isDirectory: false)
        wkWebView.loadFileURL(localHTMLUrl, allowingReadAccessTo: localHTMLUrl)
    }
}

// MARK: - WKNavigationDelegate（画面の読み込み・遷移系）
extension ContainerForWebView: WKNavigationDelegate {

    // MARK: - 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("読み込み設定（リクエスト前）")
        let url = navigationAction.request.url
        print("読み込もうとしているページ", url ?? "")
        decisionHandler(.allow)
    }

    // MARK: - 読み込み準備開始
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("読み込み準備開始")
    }

    // MARK: - 読み込み設定（レスポンス取得後）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("読み込み設定（レスポンス取得後）")
        decisionHandler(.allow)
    }

    // MARK: - 読み込み開始
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("読み込み開始")
    }

    // MARK: - ユーザ認証
    func webView(_ webView: WKWebView,
                 didReceive challenge: URLAuthenticationChallenge,
                 completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("ユーザ認証")
        completionHandler(.useCredential, nil)
    }

    // MARK: - 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Javascriptに渡す値
        let param: String = "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30&10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200,210,220,230,240,250,260,270,280,290,300"

        // Javascript側で実行する関数
        let execJsFunc: String = "getDatas(\"\(param)\");"

        webView.evaluateJavaScript(execJsFunc, completionHandler: { (object, error) -> Void in
        })
        print("読み込み完了")
    }

    // MARK: - 読み込み失敗検知
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError: Error) {
        print("読み込み失敗検知")
    }

    // MARK: - 読み込み失敗
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError: Error) {
        print("読み込み失敗")
    }

    // MARK: - リダイレクト
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation:WKNavigation!) {
        print("リダイレクト")
    }

}
