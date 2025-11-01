//
//  ContentView.swift
//  WebVIewTest
//
//  Created by 津本拓也 on 2025/09/27.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var userType: String = "guest" // 現在のクッキー値
    
    var body: some View {
        VStack {
            Button("firter") {
                let result = filter(number: [1,3,4,5,6,7,8,9,2], condition: {$0 % 2 == 0})
                print(result)
            }
            // クッキー切替 UI
            Picker("User Type", selection: $userType) {
                Text("Guest").tag("guest")
                Text("Member").tag("member")
                Text("Admin").tag("admin")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // WebView
            WebView(url: URL(string: "http://127.0.0.1:8000/")!, userType: userType)
        }
    }
    
    func filter(number: [Int], condition: (Int) -> Bool) -> Int {
        return number.filter(condition).reduce(0, +)
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    let userType: String
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        
        if let url = Bundle.main.url(forResource: userType, withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // クッキーをリクエストヘッダに手動で追加して再読み込み
        var request = URLRequest(url: url)
        request.addValue("user_type=\(userType)", forHTTPHeaderField: "Cookie")
        uiView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(userType: self.userType)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let userType: String
        
        init(userType: String) {
            self.userType = userType
        }
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url, url.scheme == "myapp" {
                print("URL: \(url)")
                switch  userType {
                case "guest":
                    if let url = URL(string: "https://www.apple.com/jp/") {
                        let request = URLRequest(url: url)
                        webView.load(request)
                    }
                case "member":
                    if let url = URL(string: "https://www.google.com") {
                        let request = URLRequest(url: url)
                        webView.load(request)
                    }
                case "admin":
                    if let url = URL(string: "https://www.amazon.co.jp/") {
                        let request = URLRequest(url: url)
                        webView.load(request)
                    }
                default:
                    print("not match path")
                }
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
        }
    }
}

