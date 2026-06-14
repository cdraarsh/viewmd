import SwiftUI
import WebKit

struct PDFStyleWebView: NSViewRepresentable {
    let html: String
    let baseURL: URL?
    @Binding var webView: WKWebView?

    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.isElementFullscreenEnabled = false

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.appearance = NSAppearance(named: .aqua)
        webView.underPageBackgroundColor = NSColor(red: 0.945, green: 0.961, blue: 0.976, alpha: 1.0) // #f1f5f9
        DispatchQueue.main.async {
            self.webView = webView
        }
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        DispatchQueue.main.async {
            self.webView = webView
        }
        webView.loadHTMLString(html, baseURL: baseURL)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated,
               let url = navigationAction.request.url {
                NSWorkspace.shared.open(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
    }
}
