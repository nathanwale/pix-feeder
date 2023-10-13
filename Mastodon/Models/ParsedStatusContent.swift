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
        case mention(name: String, url: URL?)
    }
    
    /// Errors
    enum Error: Swift.Error, CustomStringConvertible
    {
        case failedToParseMentionLink(node: Node)
        case failedToParseMentionName(node: Node)
        
        
        var description: String {
            switch self {
                case .failedToParseMentionLink(let node):
                    return message("Failed to parse link in Mention. No inner anchor found.", node: node)
                case .failedToParseMentionName(let node):
                    return message("Failed to parse name in Mention", node: node)
            }
        }
        
        func message(_ msg: String, node: Node) -> String
        {
            let html = try? node.outerHtml()
            if let html {
                return "\(msg)\nNode:\n\(html)"
            }
            return "\(msg)\nNo node information available"
        }
    }
    
    /// The Status content as an HTML string
    let html: String
    
    /// Tokens from parsing `self.html`
    var tokens: [Token]? {
        do {
            return try parseContent()
        } catch {
            print("Error parsing content:")
            print(error)
        }
        return nil
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
                    try tokens.append(parseNode(child))
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
    private func parseHashLink(_ node: Node) throws -> Token
    {
        let innerSpan = node.getChildNodes().first { $0.nodeName() == "span" }
        let hashTagName = try innerSpan!.getChildNodes().first!.outerHtml()
        let hashTagLink = try node.attr("href")
        return .hashTag(name: hashTagName, url: URL(string: hashTagLink))
    }

    /// Parse an external web link as `Token`s
    private func parseWebLink(_ node: Node) throws -> Token
    {
        let link = try node.attr("href")
        return .link(url: URL(string: link))
    }

    /// Parse `<a>` tags from content
    private func parseAnchor(_ node: Node) throws -> Token
    {
        if try node.attr("rel") == "tag"
        {
            return try parseHashLink(node)
        }
        return try parseWebLink(node)
    }
    
    /// Parse H-Card
    /// See: https://microformats.org/wiki/h-card
    private func parseMention(_ node: Node) throws -> Token
    {
        // eg. 1: <span class=\"h-card\" translate=\"no\"><a href=\"https://wandering.shop/@annaleen\" class=\"u-url mention\">@<span>annaleen</span></a></span>
        // eg. 2: <span class=\"h-card\"><a href=\"https://chitter.xyz/@codl\" class=\"u-url mention\" rel=\"nofollow noopener noreferrer\" target=\"_blank\">@<span>codl</span></a></span>
        guard let innerAnchor = node.getChildNodes().first(where: { $0.nodeName() == "a" }) else {
            throw Error.failedToParseMentionLink(node: node)
        }
        guard let innerSpan = innerAnchor.getChildNodes().first(where: { $0.nodeName() == "span" }) else {
            print(node.getChildNodes())
            throw Error.failedToParseMentionName(node: innerAnchor)
        }
        
        let urlString = try innerAnchor.attr("href")
        let url = URL(string: urlString)
        let name = try innerSpan.getChildNodes().first!.outerHtml()
        
        return .mention(name: name, url: url)
    }

    /// Parse DOM nodes found in `self.html`
    private func parseNode(_ node: Node) throws -> Token
    {
        switch node.nodeName()
        {
            case "br":
                // line break
                return .lineBreak
            case "a":
                // web link or hashtag
                return try parseAnchor(node)
            case "span":
                // may be a mention, check for h-card
                if let className = try? node.attr("class"),
                   className == "h-card" {
                    return try parseMention(node)
                }
                // else continue
                fallthrough
            default:
                // assume plain text
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
        switch self 
        {
            // Line breaks
            case .lineBreak:
                return AttributedString("\n")
                
            // Plain text
            case .text(let text):
                return AttributedString(text)
            
            // Hash tags
            case .hashTag(let name, let url):
                var hashTag = AttributedString("#\(name)")
                if let url {
                    hashTag.link = url
                    hashTag.foregroundColor = .pink
                    hashTag.font = hashTag.font?.bold()
                }
                return hashTag
                
            // Web link
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
                
            // Mentions
            case .mention(let name, let url):
                var mention = AttributedString("@\(name)")
                if let url {
                    mention.link = url
                    mention.foregroundColor = .green
                    mention.font = mention.font?.bold()
                }
                return mention
        }
    }
    
}
