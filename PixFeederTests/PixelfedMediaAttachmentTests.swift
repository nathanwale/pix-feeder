//
//  MastodonAccountTests.swift
//  Mastodon
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import PixFeeder

final class PixelfedMediaAttachmentTests: XCTestCase
{
    var attachments = [PixelfedMediaAttachment]()
    
    override func setUp() async throws
    {
        let fileUrl = Bundle(for: Self.self).url(forResource: "multiple-attachments", withExtension: "json")!
        attachments = JsonLoader.fromLocalUrl(fileUrl)
    }
    
    func testDecodeSingleAttachment() throws
    {
        let attachment = attachments[0]
        XCTAssertEqual(attachment.id, "22345792")
        XCTAssertEqual(attachment.type, PixelfedMediaAttachment.MediaType.image)
        XCTAssertEqual(attachment.previewUrl, URL(string: "https://files.mastodon.social/media_attachments/files/022/345/792/small/57859aede991da25.jpeg"))
        XCTAssertEqual(attachment.type, PixelfedMediaAttachment.MediaType.image)
        XCTAssertEqual(attachment.remoteUrl, nil)
        // text_url is deprecated
        // meta is yet to be implemented
        XCTAssertEqual(attachment.description, "test media description")
        XCTAssertEqual(attachment.blurhash, "UFBWY:8_0Jxv4mx]t8t64.%M-:IUWGWAt6M}")
    }
    
    func testDecodingManyAttachments() throws
    {
        XCTAssertEqual(attachments.count, 4)
    }
}
