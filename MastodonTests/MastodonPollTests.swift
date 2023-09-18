//
//  MastodonAccountTests.swift
//  Mastodon
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import Mastodon

final class MastodonPollTests: XCTestCase
{
    func testDecodeSinglePollFromJson() throws
    {
        let fileUrl = Bundle(for: Self.self).url(forResource: "single-poll", withExtension: "json")!
        let poll: MastodonPoll = JsonLoader.fromLocalUrl(fileUrl)
        
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
            MastodonPoll.Options(title: "accept", votesCount: 6),
            MastodonPoll.Options(title: "deny", votesCount: 4),
        ]
        
        XCTAssertEqual(poll.options, options)
    }
}
