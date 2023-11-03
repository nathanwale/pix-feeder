//
//  MastodonAccountTests.swift
//  Mastodon
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import Mastodon

final class MastodonAccountTests: XCTestCase
{
    func testDecodeSingleAccountFromJson() throws
    {
        let fileUrl = Bundle(for: Self.self).url(forResource: "single-account", withExtension: "json")!
        let account: MastodonAccount = JsonLoader.fromLocalUrl(fileUrl)
        XCTAssertEqual(account.id, "110528637375951012")
        XCTAssertEqual(account.username, "nwale")
        XCTAssertEqual(account.acct, "nwale")
        XCTAssertEqual(account.displayName, "nwale")
        XCTAssertEqual(account.locked, false)
        XCTAssertEqual(account.bot, false)
        XCTAssertEqual(account.discoverable, true)
        XCTAssertEqual(account.group, false)
        XCTAssertEqual(account.createdAt.description, "2023-10-24 07:11:40 +0000")
        XCTAssertEqual(account.note, "<p>“Queen Latifa, give me strength!” — Gene Belcher</p>")
        XCTAssertEqual(account.url, URL(string: "https://mastodon.social/@nwale"))
        XCTAssertEqual(account.uri, URL(string: "https://mastodon.social/users/nwale"))
        XCTAssertEqual(account.avatar, URL(string: "https://files.mastodon.social/accounts/avatars/110/528/637/375/951/012/original/2d14c64b7a9e1f10.jpeg"))
        XCTAssertEqual(account.avatarStatic, URL(string: "https://files.mastodon.social/accounts/avatars/110/528/637/375/951/012/original/2d14c64b7a9e1f10.jpeg"))
        XCTAssertEqual(account.header, URL(string: "https://files.mastodon.social/accounts/headers/110/528/637/375/951/012/original/c82163b760efda85.jpeg"))
        XCTAssertEqual(account.headerStatic, URL(string: "https://files.mastodon.social/accounts/headers/110/528/637/375/951/012/original/c82163b760efda85.jpeg"))
        XCTAssertEqual(account.followersCount, 3)
        XCTAssertEqual(account.followingCount, 44)
        XCTAssertEqual(account.statusesCount, 41)
        XCTAssertEqual(account.lastStatusAt?.description, "2023-09-03 00:00:00 +0000")
        XCTAssertEqual(account.noindex, false)
        XCTAssertEqual(account.emojis, [])
        XCTAssertEqual(account.fields.count, 2)
        XCTAssertEqual(account.fields[0].name, "Website")
        XCTAssertEqual(account.fields[0].value, #"<a href="https://looploopbreak.netlify.app" target="_blank" rel="nofollow noopener noreferrer me" translate="no"><span class="invisible">https://</span><span class="">looploopbreak.netlify.app</span><span class="invisible"></span></a>"#)
        XCTAssertEqual(account.fields[0].verifiedAt, nil)
        XCTAssertEqual(account.fields[1].name, "Security Clearance")
        XCTAssertEqual(account.fields[1].value, "Ultramega")
        XCTAssertEqual(account.fields[1].verifiedAt, nil)
    }
    
    func testDecodingManyAccounts() throws
    {
        let fileUrl = Bundle(for: Self.self).url(forResource: "multiple-accounts", withExtension: "json")!
        let accounts: [MastodonAccount] = JsonLoader.fromLocalUrl(fileUrl)
        XCTAssertEqual(accounts.count, 40)
    }
}
