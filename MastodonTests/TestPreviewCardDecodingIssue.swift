//
//  MastodonAccountTests.swift
//  Mastodon
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import Mastodon

struct DecodingTest: Decodable
{
    var authorName: String
    
    enum CodingKeys: String, CodingKey
    {
        case authorName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.authorName = try container.decode(String.self, forKey: .authorName)
    }
}

final class DecodingIssue: XCTestCase
{
    let singleCard = #"""
        {
          "url": "https://www.youtube.com/watch?v=OMv_EPMED8Y",
          "title": "♪ Brand New Friend (Christmas Song!)",
          "description": "",
          "type": "video",
          "author_name": "YOGSCAST Lewis & Simon",
          "author_url": "https://www.youtube.com/user/BlueXephos",
          "provider_name": "YouTube",
          "provider_url": "https://www.youtube.com/",
          "html": "<iframe width=\"480\" height=\"270\" src=\"https://www.youtube.com/embed/OMv_EPMED8Y?feature=oembed\" frameborder=\"0\" allowfullscreen=\"\"></iframe>",
          "width": 480,
          "height": 270,
          "image": "https://files.mastodon.social/preview_cards/images/014/179/145/original/9cf4b7cf5567b569.jpeg",
          "embed_url": "",
          "blurhash": "UvK0HNkV,:s9xBR%njog0fo2W=WBS5ozofV@"
        }
    """#

    func testDecodeSingleCardFromString() throws
    {
        let card: DecodingTest = JsonLoader.fromString(singleCard)
        XCTAssertEqual(card.authorName, "YOGSCAST Lewis & Simon")
    }
}
