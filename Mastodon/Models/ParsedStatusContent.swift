//
//  ParsedStatusContent.swift
//  Mastodon
//
//  Created by Nathan Wale on 6/10/2023.
//

import Foundation
import SwiftSoup
import UIKit

///
/// Mastodon Status Content that has been parsed into tokens
/// Designed for converting into styled content
///
struct ParsedStatusContent
{
    /// The tokens that are a result of the parsing
    enum Token 
    {
        case lineBreak
        case text(String)
        case hashTag(name: String, url: URL?)
        case link(url: URL?)
    }
    
    /// The Status content as an HTML string
    let html: String
    
    /// Tokens from parsing `self.html`
    var tokens: [Token]? {
        try? parseContent()
    }
    
    /// Parse the content of `self.html` as `ParsedStatusContent.Token`s
    func parseContent() throws -> [Token]
    {
        let doc = try SwiftSoup.parseBodyFragment(html)
        let body = doc.body()
        let paras = try body?.select("p").array()
        var tokens = [Token]()
        
        // html has been split into paras
        if let paras {
            for (i, p) in paras.enumerated() {
                for child in p.getChildNodes() {
                    tokens.append(parseNode(child))
                }
                // two linebreaks for end of paragraphs,
                // unless we're at the end
                if i < paras.endIndex-1 {
                    tokens.append(.lineBreak)
                    tokens.append(.lineBreak)
                }
            }
        }
        
        return tokens
    }
    
    /// Parse a HashTag link as `Token`s
    private func parseHashLink(_ node: Node) -> Token
    {
        let innerSpan = node.getChildNodes().first { $0.nodeName() == "span" }
        let hashTagName = (try? innerSpan?.getChildNodes().first?.outerHtml()) ?? "NOSPAN"
        let hashTagLink = (try? node.attr("href")) ?? ""
        return .hashTag(name: hashTagName, url: URL(string: hashTagLink))
    }

    /// Parse an external web link as `Token`s
    private func parseWebLink(_ node: Node) -> Token
    {
        let link = (try? node.attr("href")) ?? ""
        return .link(url: URL(string: link))
    }

    /// Parse `<a>` tags from content
    private func parseAnchor(_ node: Node) -> Token
    {
        if let relAttr = try? node.attr("rel"),
           relAttr == "tag"
        {
            return parseHashLink(node)
        }
        return parseWebLink(node)
    }

    /// Parse DOM nodes found in `self.html`
    private func parseNode(_ node: Node) -> Token
    {
        switch node.nodeName()
        {
            case "br":
                return .lineBreak
            case "a":
                return parseAnchor(node)
            default:
                let text = (try? node.outerHtml()) ?? ""
                return .text(text)
        }
    }
}


// MARK: - attributed strings
extension ParsedStatusContent
{
    /// Parsed Content converted to a styled AttributedString
    var attributedString: AttributedString?
    {
        tokens?.reduce(AttributedString()) {
            $0 + $1.attributedString
        }
    }
}

// Tokens
extension ParsedStatusContent.Token
{
    // Paragraph style to be attached for link truncation
    private var paragraphStyle: NSMutableParagraphStyle
    {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byTruncatingTail
        return style
    }
    
    /// Convert this token to a styled AttributedString
    var attributedString: AttributedString
    {
        switch self {
            case .lineBreak:
                return AttributedString("\n")
                
            case .text(let text):
                return AttributedString(text)
                
            case .hashTag(let name, let url):
                var hashTag = AttributedString("#\(name)")
                if let url {
                    hashTag.link = url
                    hashTag.foregroundColor = .pink
                    hashTag.font = hashTag.font?.bold()
                }
                return hashTag
                
            case .link(let url):
                if let url {
                    var link = AttributedString(url.description)
//                    -- Below doesn't seem to have any effect and causes a warning:
//                    -- "Conformance of 'NSParagraphStyle' to 'Sendable' is unavailable"
//                    link.paragraphStyle = paragraphStyle
                    link.link = url
                    return link
                } else {
                    return AttributedString("<<invalid url>>")
                }
        }
    }
    
}
