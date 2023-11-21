//
//  StatusList.swift
//  Mastodon
//
//  Created by Nathan Wale on 27/9/2023.
//

import SwiftUI
import WebKit

class TestType: Identifiable
{
    var id: Int { value }
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
}

struct TestUILabel: UIViewRepresentable
{
    typealias UIViewType = UITextView
    
    let text: String
    
    let header = ""
        
    private var attributedString: NSAttributedString
    {
//        let nsAttributedString = try! NSAttributedString(
//            data: text.data(using: .utf16)!,
//            options: [
//                .documentType: NSAttributedString.DocumentType.html
//            ],
//            documentAttributes: nil
//        )
        let html = header + text
        return try! NSAttributedString(
            data: html.data(using: .utf8)!,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
    }
    
    func makeUIView(context: Context) -> UIViewType {
        UIViewType()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.isEditable = false
        uiView.attributedText = attributedString
    }
}

struct TestWKView: UIViewRepresentable
{
    let html: String
    let header = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(header + html, baseURL: nil)
    }
    
    typealias UIViewType = WKWebView
    
    
}

struct TestViewRow: View
{
    let text: String
        
    private var nsAttributedString: NSAttributedString
    {
        try! NSAttributedString(
            data: text.data(using: .utf8)!,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
    }
    
    private var attributedString: AttributedString
    {
//        let nsAttributedString = try! NSAttributedString(
//            data: text.data(using: .utf16)!,
//            options: [
//                .documentType: NSAttributedString.DocumentType.html
//            ],
//            documentAttributes: nil
//        )
        
        
        
        return try! AttributedString(nsAttributedString, including: \.uiKit)
    }
    
    var body: some View
    {
        Text(attributedString)
    }
}

struct ListTestView: View
{
    var list: [TestType]
    
    struct Row: View
    {
        let item: TestType
        var body: some View
        {
            LazyVStack
            {
                let s = item.value.description
                //                HtmlView(html: item.value.description)
                Text("Regular: ") + Text(s)
                //                TestViewRow(text: s)
                HStack
                {
                    Text("UILabel: ")
                    TestUILabel(text: s)
                }
            }
        }
    }
    
    var body: some View
    {
        ScrollView
        {
            LazyVStack
            {
                ForEach(list)
                {
                    item in
                    Row(item: item)
                        .padding(.bottom, 100)
                        .listRowSeparator(.hidden)
                        .listRowInsets(
                            .init(top: 20, leading: 0, bottom: 100, trailing: 0))
                }
            }
        }
    }
}

#Preview {
    let list = Array(0...100).map {
        TestType(value: $0)
    }
    return ListTestView(list: list).padding()
}
