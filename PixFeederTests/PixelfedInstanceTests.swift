//
//  PixFeeder
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import PixFeeder

final class PixelfedInstanceTests: XCTestCase
{
    var instance: PixelfedInstance!
    
    override func setUp() async throws 
    {
        let fileUrl = Bundle(for: Self.self).url(forResource: "instance-data", withExtension: "json")!
        instance = JsonLoader.fromLocalUrl(fileUrl)
    }
    
    func testDecodeInstanceFromJson() throws
    {
        XCTAssertEqual(instance.uri.description, "pixelfed.social")
        XCTAssertEqual(instance.title, "pixelfed")
        XCTAssertEqual(instance.version, "2.7.2 (compatible; Pixelfed 0.11.9)")
        XCTAssertEqual(instance.description, "The original Pixelfed instance, operated by the main developer @dansup")
        XCTAssertEqual(instance.shortDescription, "The original Pixelfed instance, operated by the main developer @dansup")
        XCTAssertEqual(instance.thumbnail.description, "https://pixelfed.social/storage/headers/Hb2Qs2gfWofB4kEmSRArGqfr0h3DeBgrjLcwZ23r.jpg")
        XCTAssertEqual(instance.languages, ["en"])
        XCTAssertEqual(instance.approvalRequired, false)
        XCTAssertEqual(instance.registrations, true)
        
        // Contact
        XCTAssertEqual(instance.email, "hello@pixelfed.org")
        XCTAssertEqual(instance.contactAccount.displayName, "dansup")
        XCTAssertEqual(instance.contactAccount.id, "2")
        
        // Rules
        let rules = instance.rules
        XCTAssertEqual(rules.count, 6)
        
        let rule = rules[4]
        XCTAssertEqual(rule.id, "5")
        XCTAssertEqual(rule.text, "No content illegal in United States")
    }
    
    func testDecodeInstanceConfigurationFromJson() throws
    {
        let config = instance.configuration
        
        // status policy
        let statuses = config.statuses
        XCTAssertEqual(statuses.maxCharacters, 2000)
        XCTAssertEqual(statuses.maxMediaAttachments, 10)
        XCTAssertEqual(statuses.charactersReservedPerUrl, 23)
        
        // media attachment policy
        let attachments = config.mediaAttachments
        XCTAssertEqual(attachments.imageSizeLimit, 15360000)
        XCTAssertEqual(attachments.imageMatrixLimit, 16777216)
        XCTAssertEqual(attachments.videoSizeLimit, 15360000)
        XCTAssertEqual(attachments.videoFrameRateLimit, 120)
        XCTAssertEqual(attachments.videoMatrixLimit, 2304000)
        
        //... MIME types
        let mimeTypes = attachments.supportedMimeTypes
        XCTAssertEqual(mimeTypes.count, 4)
        XCTAssertEqual(mimeTypes.last, "video/mp4")
        
        // poll policy
        let polls = config.polls
        XCTAssertEqual(polls.maxOptions, 4)
        XCTAssertEqual(polls.maxCharactersPerOption, 50)
        XCTAssertEqual(polls.minExpiration, 300)
        XCTAssertEqual(polls.maxExpiration, 2629746)
    }
}
