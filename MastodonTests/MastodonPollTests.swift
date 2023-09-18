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
    }
}
