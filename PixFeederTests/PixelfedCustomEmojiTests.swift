//
//  MastodonAccountTests.swift
//  Mastodon
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import PixFeeder

final class PixelfedCustomEmojiTests: XCTestCase
{
    func testDecodeSingleCustomEmojiFromJson() throws
    {
        let fileUrl = Bundle(for: Self.self).url(forResource: "single-custom-emoji", withExtension: "json")!
        let emoji: PixelfedCustomEmoji = JsonLoader.fromLocalUrl(fileUrl)
        
        XCTAssertEqual(emoji.shortcode, "blobaww")
        XCTAssertEqual(emoji.url, URL(string: "https://files.mastodon.social/custom_emojis/images/000/011/739/original/blobaww.png"))
        XCTAssertEqual(emoji.staticUrl, URL(string: "https://files.mastodon.social/custom_emojis/images/000/011/739/static/blobaww.png"))
        XCTAssertEqual(emoji.visibleInPicker, true)
        XCTAssertEqual(emoji.category, "Blobs")
    }
}
