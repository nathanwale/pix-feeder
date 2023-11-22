//
//  ParsedText+PlainString.swift
//  PixFeeder
//
//  Created by Nathan Wale on 24/10/2023.
//

import Foundation

///
/// Parse text to find custom emoji
///
extension ParsedText
{
    /// regex to find custom emoji
    static let emojiRegex = /:([^\s]*):/.repetitionBehavior(.reluctant)
    
    /// Convert text to Tokens
    func parse(plainText string: String) -> [Token]
    {
        var tokens = [Token]()
        let matches = string.matches(of: ParsedText.emojiRegex)
        var lower = string.startIndex
        var upper = string.endIndex
        
        for match in matches {
            let emojiName = match.output.1
            upper = match.range.lowerBound
            tokens.append(.text(String(string[lower..<upper])))
            tokens.append(.emoji(name: String(emojiName)))
            
            lower = match.range.upperBound
        }
        tokens.append(.text(String(string[lower..<string.endIndex])))
        
        return tokens
    }
}
