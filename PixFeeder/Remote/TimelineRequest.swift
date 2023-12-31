//
//  TimelineRequest.swift
//  PixFeeder
//
//  Created by Nathan Wale on 2/11/2023.
//

import Foundation

enum ApiQueryTimeFrame 
{
    case before(PixelfedStatus)
    case after(PixelfedStatus)
    
    var queryItem: URLQueryItem {
        switch self {
            case .before(let status):
                return .init(name: "since_id", value: status.id)
            case .after(let status):
                return .init(name: "min_id", value: status.id)
        }
    }
}

///
/// An API Request that returns Statuses
///
protocol PixelfedStatusRequest: ApiRequest where Response == [PixelfedStatus] 
{
    /// The host of the server. Eg.: "mastodon.social"
    var host: String { get }
    
    /// Time frame for Statuses
    var timeFrame: ApiQueryTimeFrame? { get set }
}

///
/// Defaults for PixelfedStatusRequest
/// - limit: The max number of Statuses that will be returned
///
extension PixelfedStatusRequest
{
    /// The max number of Statuses that will be returned
    var limit: Int { 20 }
    
    /// query items
    var queryItems: [URLQueryItem]? {
        var items = [
            URLQueryItem(name: "limit", value: String(limit)),
        ]
        
        if let timeFrame {
            items.append(timeFrame.queryItem)
        }
        
        return items
    }
}

///
/// A Public Timeline Request: will return public statuses that have just been posted
///
struct PublicTimelineRequest: PixelfedStatusRequest
{
    let host: String
    let endpoint = "timelines/public"
    var timeFrame: ApiQueryTimeFrame?
}

///
/// A Timeline Request for a particular account
/// - userid: The Account ID for the User
///
struct UserTimelineRequest: PixelfedStatusRequest
{
    let host: String
    let userid: PixelfedAccountId
    var timeFrame: ApiQueryTimeFrame?
    
    var endpoint: String {
        "accounts/\(userid)/statuses"
    }
}

