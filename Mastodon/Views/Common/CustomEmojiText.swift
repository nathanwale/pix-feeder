//
//  CustomEmojiText.swift
//  Mastodon
//
//  Created by Nathan Wale on 16/10/2023.
//

import SwiftUI
import RegexBuilder

///
/// Parse text to find custom emoji
///
struct CustomEmojiParser
{
    /// String to parse
    let string: String
    
    /// regex to find custom emoji
    let regex = /:(.*):/.repetitionBehavior(.reluctant)
    
    /// A Token found by parser
    enum Token {
        case text(String)
        case emoji(String)
    }
    
    /// Convert text to Tokens
    func tokenise() -> [Token]
    {
        var tokens = [Token]()
        let matches = string.matches(of: regex)
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


///
/// Display text with custom emoji inserted
///
struct CustomEmojiText: View
{
    /// Mapping of Emoji names to image URLs
    typealias EmojiUrlTable = [String: URL?]
    
    /// Mapping of Emoji names to images
    typealias EmojiImageTable = [String: UIImage?]
    
    /// Tokens found by parser
    private let tokens: [CustomEmojiParser.Token]
    
    /// URLs for emoji names
    let emojiUrls: EmojiUrlTable
    
    /// Image to use for image loading errors
    let errorImage = Icon.notFound.uiImage!
    
    /// Original text before parsing
    let text: String
    
    /// Images for emoji names
    @State private var emojiImages: EmojiImageTable?
    
    /// Line height, caclulated on appearance
    @State private var lineHeight = UIFont.preferredFont(forTextStyle: .body).pointSize
    
    /// Init
    /// - text: Text to parse and display
    /// - emojiUrls: Emoji names with associated image URLs
    init(_ text: String, emojiUrls: EmojiUrlTable)
    {
        self.text = text
        tokens = CustomEmojiParser(string: text).tokenise()
        self.emojiUrls = emojiUrls
    }
    
    /// Body view
    var body: some View
    {
        Group {
            if let emojiImages {
                textWithFetchedEmojis(emojis: emojiImages)
            } else {
                placeHolder
            }
        }.task {
            emojiImages = await fetchEmojis()
        }
    }
        
    /// Placeholder to display while parsing text
    // Also reads the line height
    var placeHolder: some View
    {
        Text("...")
            .background {
                // For reading the line height
                GeometryReader
                {
                    geo in
                    Color.clear
                        .onAppear {
                            // assign line height
                            lineHeight = geo.size.height
                        }
                }
            }
    }
    
    /// Fetch emojis and build final text view
    private func textWithFetchedEmojis(emojis: EmojiImageTable) -> some View
    {
        tokens.reduce(Text("")) {
            switch $1 {
                case .emoji(let name):
                    let uiImage = emojis[name] ?? errorImage
                    let image = Image(uiImage: uiImage ?? errorImage).resizable()
                    let textView = Text(image)
                        .baselineOffset(lineHeight * -0.2)
                    return $0 + textView
                case .text(let text):
                    return $0 + Text(text)
            }
        }
    }
    
    /// Fetch all emojis in `emojiUrls`
    func fetchEmojis() async -> EmojiImageTable
    {
        var result = EmojiImageTable()
        for (name, url) in emojiUrls {
            let image = try? await fetchEmoji(name: name, url: url)
            result[name] = image
        }
        return result
    }
    
    /// Fetch an emoji
    /// - name: name of the emoji
    /// - url: URL of the emoji image
    func fetchEmoji(name: String, url: URL?) async throws -> UIImage?
    {
        var image: UIImage?
        
        
        if let url
        {
            let request = ImageRequest(url: url)
            let originalImage = try await request.send()
            let imageView = Image(uiImage: originalImage)
                .resizable()
                .scaledToFit()
                .frame(height: lineHeight)
            // No idea what this "non-sendable" warning is about
            let renderer = await ImageRenderer(content: imageView)
            if let image = await renderer.uiImage {
                return image
            }
        } else {
            image = Icon.smile.uiImage!
        }
        return image
    }
    
}


// MARK: - previews
#Preview
{
    let emojis = [
        "smile": URL(string: "https://files.mastodon.social/cache/custom_emojis/images/000/736/060/original/8297d56b528eb387.gif"),
        "ablobcatangel": URL(string: "https://files.mastodon.social/cache/custom_emojis/images/000/471/468/original/db6a6fc28fd8387d.png"),
        "nonbinary_flag": URL(string: "https://files.mastodon.social/cache/custom_emojis/images/000/444/562/original/2e03a662e42f72c9.png"),
        "blobcatrainbow": URL(string: "https://files.mastodon.social/cache/custom_emojis/images/000/067/996/original/bab6232f6464d285.png"),
    ]
    return VStack
    {
        CustomEmojiText("Hello! :smile: How's it going? A blob cat angel :ablobcatangel:! Non binary flag :nonbinary_flag:! A blob cat with rainbow :blobcatrainbow:! This one doesn't exist! On purpose! -->:nonexistant:<--", emojiUrls: emojis)
            .padding()
        Divider()
        CustomEmojiText("This one doesn't have any emojis", emojiUrls: [:])
        Divider()
        CustomEmojiText("Some larger text emoji! :ablobcatangel:", emojiUrls: emojis)
            .font(.title)
        Spacer()
    }
}
