//
//  HtmlView.swift
//  Mastodon
//
//  Created by Nathan Wale on 19/9/2023.
//

import SwiftUI

struct HtmlView: View
{
    let html: String
    
    private let style = """
        <style>
            * {
                font-family: sans-serif;
            }
        </style>
    """
    
    private var attributedString: AttributedString
    {
        let htmlDoc = style + html
        
        let nsAttributedString = try! NSAttributedString(
            data: htmlDoc.data(using: .utf8)!,
            options: [
                .documentType: NSAttributedString.DocumentType.html
            ],
            documentAttributes: nil
        )
        
        return AttributedString(nsAttributedString)
    }
    
    var body: some View
    {
        Text(attributedString)
    }
}

struct HtmlView_Previews: PreviewProvider
{
    static var previews: some View
    {
        HtmlView(html: """
        <p>The Pre-Raphaelites obsession with the wombat. <a href="https://mastodon.social/tags/australia" class="mention hashtag" rel="tag">#<span>australia</span></a> <a href="https://mastodon.social/tags/animals" class="mention hashtag" rel="tag">#<span>animals</span></a><br /><a href="https://publicdomainreview.org/essay/o-uommibatto-how-the-pre-raphaelites-became-obsessed-with-the-wombat/" target="_blank" rel="nofollow noopener noreferrer" translate="no"><span class="invisible">https://</span><span class="ellipsis">publicdomainreview.org/essay/o</span><span class="invisible">-uommibatto-how-the-pre-raphaelites-became-obsessed-with-the-wombat/</span></a></p>
        """)
    }
}
