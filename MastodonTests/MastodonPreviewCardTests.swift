//
//  MastodonAccountTests.swift
//  Mastodon
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import Mastodon

final class MastodonPreviewCardTests: XCTestCase
{    
    var cards = [MastodonPreviewCard]()
    
    override func setUp() async throws
    {
        let fileUrl = Bundle(for: Self.self).url(forResource: "multiple-preview-cards", withExtension: "json")!
        cards = JsonLoader.fromLocalUrl(fileUrl)
    }

    
    func testDecodeSingleCard() throws
    {
        let card = cards[0]
        
        XCTAssertEqual(card.url.description, "https://www.youtube.com/watch?v=OMv_EPMED8Y")
        XCTAssertEqual(card.title, "♪ Brand New Friend (Christmas Song!)")
        XCTAssertEqual(card.description, "")
        XCTAssertEqual(card.type, MastodonPreviewCard.PreviewCardType.video)
        XCTAssertEqual(card.authorName, "YOGSCAST Lewis & Simon")
        XCTAssertEqual(card.authorUrl?.description, "https://www.youtube.com/user/BlueXephos")
        XCTAssertEqual(card.providerName, "YouTube")
        XCTAssertEqual(card.providerUrl?.description, "https://www.youtube.com/")
        XCTAssertEqual(card.html, "<iframe width=\"480\" height=\"270\" src=\"https://www.youtube.com/embed/OMv_EPMED8Y?feature=oembed\" frameborder=\"0\" allowfullscreen=\"\"></iframe>")
        XCTAssertEqual(card.width, 480)
        XCTAssertEqual(card.height, 270)
        XCTAssertEqual(card.imageUrl?.description, "https://files.mastodon.social/preview_cards/images/014/179/145/original/9cf4b7cf5567b569.jpeg")
        XCTAssertEqual(card.embedUrl, nil)
        XCTAssertEqual(card.blurhash, Optional("UvK0HNkV,:s9xBR%njog0fo2W=WBS5ozofV@"))
    }
    
    func testDecodingManyCard() throws
    {
        XCTAssertEqual(cards.count, 4)
    }
}
