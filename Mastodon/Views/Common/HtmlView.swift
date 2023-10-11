//
//  HtmlView.swift
//  Mastodon
//
//  Created by Nathan Wale on 19/9/2023.
//

import SwiftUI

struct HtmlView: UIViewRepresentable
{
    typealias UIViewType = UITextView
    
    let html: String
    
    private let options: [NSAttributedString.DocumentReadingOptionKey: Any]  = [
        .documentType: NSAttributedString.DocumentType.html
    ]
    
    private var styledHtml: String
    {
        "<div style='font-family: sans-serif; font-size: \(UIFont.systemFontSize)'>\(html)</div>"
    }
        
    private var attributedString: NSAttributedString
    {
        return try! NSAttributedString(
            data: styledHtml.data(using: .unicode)!,
            options: options,
            documentAttributes: nil)
    }
        
    func makeUIView(context: Context) -> UIViewType 
    {
        let view = UIViewType()
        view.textContainer.lineFragmentPadding = 0
        view.textContainerInset = .zero
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) 
    {
        uiView.isEditable = false
        uiView.attributedText = attributedString
        uiView.isScrollEnabled = false
    }
    
    ///
    /// Calculate an appropriate size for this view
    ///
    // Stolen from https://stackoverflow.com/questions/60732680/how-to-get-dynamic-height-for-uitextview-in-swiftui
    func sizeThatFits(
        _ proposal: ProposedViewSize,
        uiView: UITextView,
        context: Context) -> CGSize?
    {
        let dimensions = proposal.replacingUnspecifiedDimensions(
            by: .init(
                width: 0,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
        
        let calculatedRect = calculateViewHeight(
            containerSize: dimensions,
            attributedString: uiView.attributedText
        )
        
        return calculatedRect.size
    }
    
    // Stolen from https://stackoverflow.com/questions/60732680/how-to-get-dynamic-height-for-uitextview-in-swiftui
    func calculateViewHeight(
        containerSize: CGSize,
        attributedString: NSAttributedString) -> CGRect
    {
        let rect = attributedString.boundingRect(
            with: .init(width: containerSize.width, height: containerSize.height),
            options: [
                .usesLineFragmentOrigin,
                .usesFontLeading,
            ],
            context: nil
        )
        
        return rect
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
