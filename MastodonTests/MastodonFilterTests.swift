//
//  MastodonAccountTests.swift
//  Mastodon
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import Mastodon

final class MastodonFilterTests: XCTestCase
{
    func testDecodeSingleFilterFromJson() throws
    {
        let fileUrl = Bundle(for: Self.self).url(
            forResource: "single-filter",
            withExtension: "json")!
        
        let filter: MastodonFilter = JsonLoader.fromLocalUrl(fileUrl)
        
        let keyword = MastodonFilter.Keyword(
            id: "1197",
            keyword: "bad word",
            wholeWord: false
        )
        
        let status = MastodonFilter.Status(id: "1", statusId: "109031743575371913")
        
        XCTAssertEqual(filter.id, "19972")
        XCTAssertEqual(filter.title, "Test filter")
        XCTAssertEqual(filter.context, [MastodonFilter.Context.home])
        XCTAssertEqual(filter.expiresAt?.description, "2022-09-20 17:27:39 +0000")
        XCTAssertEqual(filter.filterAction, MastodonFilter.Action.warn)
        XCTAssertEqual(filter.keywords, [keyword])
        XCTAssertEqual(filter.statuses, [status])
    }
}
