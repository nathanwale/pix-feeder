//
//  CustomEmojiText.swift
//  Mastodon
//
//  Created by Nathan Wale on 16/10/2023.
//

import SwiftUI
import RegexBuilder




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
    private let tokens: [ParsedText.Token]
    
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
        let parsedText = ParsedText(plain: text)
        tokens = parsedText.tokens
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
                // Emojis
                case .emoji(let name):
                    let uiImage = emojis[name] ?? errorImage
                    let image = Image(uiImage: uiImage ?? errorImage).resizable()
                    let textView = Text(image)
                        .baselineOffset(lineHeight * -0.2)
                    return $0 + textView
                
                // Plain text
                case .text(let text):
                    return $0 + Text(text)
                
                // Ignore others, as we don't parse them
                default:
                    return $0 + Text("")
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
    let emojis = MastodonCustomEmoji.sampleEmojis
    
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
