//
//  TimelineRequest.swift
//  Mastodon
//
//  Created by Nathan Wale on 2/11/2023.
//

import Foundation

protocol MastodonStatusRequest: ApiRequest where Response == [MastodonStatus] {}

struct PublicTimelineRequest: MastodonStatusRequest
{
    let host: String
    
    let limit = 20
    
    let endpoint = "timelines/public"
    
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "limit", value: "10")]
    }
}


struct UserTimelineRequest: MastodonStatusRequest
{
    let host: String
    let userid: MastodonAccountId
    
    let limit = 20
    
    var endpoint: String {
        "accounts/\(userid)/statuses"
    }
    
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "limit", value: "10")]
    }
}
