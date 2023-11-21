//
//  StatusContent.swift
//  Mastodon
//
//  Created by Nathan Wale on 6/10/2023.
//

import SwiftUI
import UIKit


///
/// Display the content of a Status Post
///
struct StatusContent: View
{
    /// Content as an HTML fragment
    let content: String
    
    /// Content after being parsed
    let parsedContent: ParsedText
    
    // Take HTML fragment as init
    init(_ content: String)
    {
        self.content = content
        self.parsedContent = ParsedText(html: content)
    }
        
    // Body
    var body: some View
    {
        CustomEmojiText(tokens: parsedContent.tokens, emojiUrls: PixelfedCustomEmoji.sampleEmojis)
    }
}


// MARK: - Previews
#Preview 
{
    let contents = PixelfedStatus.previews.map {
        c in
        c.reblog?.content ?? c.content ?? ""
    }
    return List(contents, id: \.self)
    {
        StatusContent($0)
    }
}
