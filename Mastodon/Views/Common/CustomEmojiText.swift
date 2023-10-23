//
//  CustomEmojiText.swift
//  Mastodon
//
//  Created by Nathan Wale on 16/10/2023.
//

import SwiftUI
import RegexBuilder

struct CustomEmojiParser
{
    let string: String
    
    var regex = /:(.*):/.repetitionBehavior(.reluctant)
    
    enum Token {
        case text(String)
        case emoji(String)
    }
    
    
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

struct CustomEmojiText: View 
{
    typealias EmojiUrlTable = [String: URL?]
    typealias EmojiImageTable = [String: UIImage?]
    
    private let tokens: [CustomEmojiParser.Token]
    
    let emojiUrls: EmojiUrlTable
    let errorImage = Icon.notFound.uiImage!
    let fontSize = UIFont.preferredFont(forTextStyle: .body).pointSize
        
    @State private var emojiImages: EmojiImageTable?
    
    init(_ text: String, emojiUrls: EmojiUrlTable)
    {
        tokens = CustomEmojiParser(string: text).tokenise()
        self.emojiUrls = emojiUrls
    }
    
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
    
    var placeHolder: some View
    {
        Text("...")
    }
    
    private func textWithFetchedEmojis(emojis: EmojiImageTable) -> some View
    {
        tokens.reduce(Text("")) {
            switch $1 {
                case .emoji(let name):
                    let uiImage = emojis[name] ?? errorImage
                    let image = Image(uiImage: uiImage ?? errorImage).resizable()
                    let textView = Text(image)
                        .baselineOffset(fontSize * -0.2)
                    return $0 + textView
                case .text(let text):
                    return $0 + Text(text)
            }
        }
    }
    
    func fetchEmojis() async -> EmojiImageTable
    {
        var result = EmojiImageTable()
        for (name, url) in emojiUrls {
            let image = try? await fetchEmoji(name: name, url: url)
            result[name] = image
        }
        return result
    }
    
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
                .frame(height: fontSize)
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
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
    }
}
