//
//  MastodonAccountTests.swift
//  Mastodon
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import PixFeeder

final class PixelfedMediaStatusTests: XCTestCase
{
    var statuses = [PixelfedStatus]()
    
    override func setUp() async throws
    {
        let fileUrl = Bundle(for: Self.self).url(forResource: "multiple-statuses", withExtension: "json")!
        statuses = JsonLoader.fromLocalUrl(fileUrl)
    }
    
    func testDecodeSingleStatus() throws
    {
        let status = statuses[0]
        XCTAssertEqual(status.id, "103270115826048975")
        XCTAssertEqual(status.createdAt.description, "2019-12-08 03:48:33 +0000")
        XCTAssertEqual(status.inReplyToId, nil)
        XCTAssertEqual(status.inReplyToAccountId, nil)
        XCTAssertEqual(status.sensitive, false)
        XCTAssertEqual(status.spoilerText, "")
        XCTAssertEqual(status.visibility, PixelfedStatus.StatusVisibility.public)
        XCTAssertEqual(status.language, "en")
        XCTAssertEqual(status.uri,
            URL(string: "https://mastodon.social/users/Gargron/statuses/103270115826048975"))
        XCTAssertEqual(status.url,
            URL(string: "https://mastodon.social/@Gargron/103270115826048975"))
        XCTAssertEqual(status.repliesCount, 5)
        XCTAssertEqual(status.reblogsCount, 6)
        XCTAssertEqual(status.favouritesCount, 11)
        XCTAssertEqual(status.favourited, false)
        XCTAssertEqual(status.reblogged, false)
        XCTAssertEqual(status.muted, false)
        XCTAssertEqual(status.bookmarked, false)
        XCTAssertEqual(status.content,
            "<p>&quot;I lost my inheritance with one wrong digit on my sort code&quot;</p><p><a href=\"https://www.theguardian.com/money/2019/dec/07/i-lost-my-193000-inheritance-with-one-wrong-digit-on-my-sort-code\" rel=\"nofollow noopener noreferrer\" target=\"_blank\"><span class=\"invisible\">https://www.</span><span class=\"ellipsis\">theguardian.com/money/2019/dec</span><span class=\"invisible\">/07/i-lost-my-193000-inheritance-with-one-wrong-digit-on-my-sort-code</span}</p>")
        XCTAssertNil(status.reblog)
        XCTAssertEqual(status.application?.name, "Web")
        XCTAssertEqual(status.application?.website, nil)
        XCTAssertEqual(status.account.username, "Gargron")
        XCTAssertEqual(status.mediaAttachments, [])
        XCTAssertEqual(status.mentions, [])
        XCTAssertEqual(status.tags, [])
        XCTAssertEqual(status.emojis, [])
        XCTAssertEqual(status.card?.title,
            "‘I lost my £193,000 inheritance – with one wrong digit on my sort code’")
        XCTAssertNil(status.poll)
    }
    
    func testDecodingManyStatuses() throws
    {
        XCTAssertEqual(statuses.count, 38)
    }
}
