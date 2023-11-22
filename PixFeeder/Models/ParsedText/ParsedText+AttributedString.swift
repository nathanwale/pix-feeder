//
//  ParsedText+AttributedString.swift
//  PixFeeder
//
//  Created by Nathan Wale on 24/10/2023.
//

import Foundation
import UIKit

///
/// Convert ParsedText to an attributed String
///
extension ParsedText
{
    /// Parsed Content converted to a styled AttributedString
    var attributedString: AttributedString?
    {
        tokens.reduce(AttributedString()) {
            $0 + $1.attributedString
        }
    }
}

///
/// Convert a Token to attributedString
///
extension ParsedText.Token
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
                
            // Custom Emoji
            case .emoji(let name):
                // Note, this doesn't actually work at the moment.
                // Image attachments don't appear in SwiftUI
//                let attachment = NSTextAttachment(image: Icon.smile.uiImage!)
//                attachment.accessibilityLabel = "Smile"
//                let attributedString = AttributedString(
//                    "<<emoji: \(name) [\(UnicodeScalar(NSTextAttachment.character)!)]>>",
//                    attributes: AttributeContainer.attachment(attachment)
//                )
//                return attributedString
                return AttributedString("<<emoji: \(name)>>")
        }
    }
    
}
