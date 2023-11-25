//
//  FileWebKitViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 11/25/23.
//

import UIKit
import SnapKit
import WebKit


class FileWebKitViewController: UIViewController, WKUIDelegate {
    
    private var webView: WKWebView!
    private var excelFileURL: URL!
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    convenience init(excelFileURL: URL) {
        self.init()
        self.excelFileURL = excelFileURL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadExcelFile()
    }
    
    private func setupWebView() {
        view.backgroundColor = .white
        webView = WKWebView()
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    private func loadExcelFile() {
        loadingIndicator.startAnimating()
        webView.load(URLRequest(url: excelFileURL))
    }
}


extension FileWebKitViewController: WKNavigationDelegate {
    
    // 엑셀 파일 바로 미리 보기
    func previewExcelFile(withURL url: URL) {
        // WKWebView 인스턴스 생성
        let webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        // 엑셀 파일 로드
        webView.load(URLRequest(url: url))
    }
    
    // WKNavigationDelegate 메서드 - 페이지 로드 완료 시 호출됩니다.
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
}
