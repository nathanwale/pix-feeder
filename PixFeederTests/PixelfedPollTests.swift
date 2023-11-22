//
//  MastodonAccountTests.swift
//  Mastodon
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import PixFeeder

final class PixelfedPollTests: XCTestCase
{
    func testDecodeSinglePollFromJson() throws
    {
        let fileUrl = Bundle(for: Self.self).url(forResource: "single-poll", withExtension: "json")!
        let poll: PixelfedPoll = JsonLoader.fromLocalUrl(fileUrl)
        
        XCTAssertEqual(poll.id, "34830")
        XCTAssertEqual(poll.expiresAt!.description, "2019-12-05 04:05:08 +0000")
        XCTAssertEqual(poll.expired, true)
        XCTAssertEqual(poll.multiple, false)
        XCTAssertEqual(poll.votesCount, 10)
        XCTAssertEqual(poll.votersCount, nil)
        XCTAssertEqual(poll.voted, true)
        XCTAssertEqual(poll.ownVotes, [1])
        XCTAssertEqual(poll.emojis, [])
        
        let options = [
            PixelfedPoll.Options(title: "accept", votesCount: 6),
            PixelfedPoll.Options(title: "deny", votesCount: 4),
        ]
        
        XCTAssertEqual(poll.options, options)
    }
}
