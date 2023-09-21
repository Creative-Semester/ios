//
//  WebViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/09/18.
//

import Foundation
import UIKit
import WebKit

class WebViewController : UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var loadingIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .red
        // 웹 뷰 생성
        webView = WKWebView(frame: self.view.bounds)
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        // 로딩 인디케이터 생성
        loadingIndicator = UIActivityIndicatorView(style: .gray)
        loadingIndicator.center = self.view.center
        self.view.addSubview(loadingIndicator)
        if let url = URL(string: "https://do.sejong.ac.kr/ko/program/all/list/all/2"){
            // 웹 페이지를 로드하기 전에 로딩 화면 표시
            loadingIndicator.startAnimating()
            // 웹 페이지를 로드
            let request = URLRequest(url:url)
            webView.load(request)
        }
    }
    // 웹 페이지 로딩이 시작될 때 호출되는 메서드
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // 로딩 화면 표시
        loadingIndicator.startAnimating()
    }
    // 웹 페이지 로딩이 종료될 때 호출되는 메서드
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 로딩 화면 숨김
        loadingIndicator.stopAnimating()
    }
}
