//
//  PixFeeder
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import PixFeeder

fileprivate let sampleUserId = "110528637375951012" // this is @nwale
fileprivate let sampleHost = "mastodon.social"

final class PixelfedOnlineStatusTests: XCTestCase
{
    
    func testOnlineStatuses() async throws
    {
        let request = UserTimelineRequest(host: sampleHost, userid: sampleUserId)
        let statuses = try await request.send()
        XCTAssertGreaterThan(statuses.count, 0)
    }
}
