//
//  ParsedText+PlainString.swift
//  Mastodon
//
//  Created by Nathan Wale on 24/10/2023.
//

import Foundation

///
/// Parse text to find custom emoji
///
extension ParsedText
{
    /// Convert text to Tokens
    func parse(plain string: String) -> [Token]
    {
        /// regex to find custom emoji
        let emojiRegex = /:(.*):/.repetitionBehavior(.reluctant)
        
        var tokens = [Token]()
        let matches = string.matches(of: emojiRegex)
        var lower = string.startIndex
        var upper = string.endIndex
        
        for match in matches {
            let emojiName = match.output.1
            upper = match.range.lowerBound
            tokens.append(.text(String(string[lower..<upper])))
            tokens.append(.emoji(String(emojiName)))
            
            lower = match.range.upperBound
        }
        tokens.append(.text(String(string[lower..<string.endIndex])))
        
        return tokens
    }
}
