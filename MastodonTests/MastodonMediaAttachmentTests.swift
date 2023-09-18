//
//  MastodonAccountTests.swift
//  Mastodon
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import Mastodon

final class MastodonMediaAttachmentTests: XCTestCase
{
    var attachments = [MastodonMediaAttachment]()
    
    override func setUp() async throws
    {
        let fileUrl = Bundle(for: Self.self).url(forResource: "multiple-attachments", withExtension: "json")!
        attachments = JsonLoader.fromLocalUrl(fileUrl)
    }
    
    func testDecodeSingleAttachment() throws
    {
        let attachment = attachments[0]
        XCTAssertEqual(attachment.id, "22345792")
    }
    
    func testDecodingManyAttachments() throws
    {
        XCTAssertEqual(attachments.count, 4)
    }
}
