//
//  MastodonAccountTests.swift
//  Mastodon
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import PixFeeder

final class DateFormattingTests: XCTestCase
{    
    func testHoursAgoProperty() throws
    {
        // Should be in minutes
        XCTAssertEqual(
            Calendar.current.date(byAdding: .minute, value: -59, to: .now)?.hoursAgo,
            0)
        
        // 1 hour
        XCTAssertEqual(
            Calendar.current.date(byAdding: .hour, value: -1, to: .now)?.hoursAgo,
            1)
        
        // 23 hours
        XCTAssertEqual(
            Calendar.current.date(byAdding: .hour, value: -23, to: .now)?.hoursAgo,
            23)
        
        // 24 hours
        XCTAssertEqual(
            Calendar.current.date(byAdding: .hour, value: -24, to: .now)?.hoursAgo,
            24)
        
        // 25 hours
        XCTAssertEqual(
            Calendar.current.date(byAdding: .hour, value: -25, to: .now)?.hoursAgo,
            25)
    }
    
    
    func testRelativeFormattingHoursAgo() throws
    {
        // Should be in minutes
        XCTAssertEqual(
            Calendar.current.date(byAdding: .minute, value: -59, to: .now)?.relativeFormatted,
            "0 hours ago")
        
        // 1 hour
        XCTAssertEqual(
            Calendar.current.date(byAdding: .hour, value: -1, to: .now)?.relativeFormatted,
            "1 hour ago")
        
        // 23 hours
        XCTAssertEqual(
            Calendar.current.date(byAdding: .hour, value: -23, to: .now)?.relativeFormatted,
            "23 hours ago")
        
        // Should be in days
        XCTAssertEqual(
            Calendar.current.date(byAdding: .hour, value: -24, to: .now)?.relativeFormatted,
            "1 day ago")
    }
}
