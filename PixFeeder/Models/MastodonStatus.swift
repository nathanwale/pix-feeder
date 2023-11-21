//
//  MastodonStatus.swift
//  Mastodon
//
//  Created by Nathan Wale on 7/9/2023.
//

import Foundation

class MastodonStatus: Codable, Identifiable
{
    /// Status ID
    var id: Identifier!
    
    /// URI of the status used for federation
    var uri: URL!
    
    /// The date this status was created
    var createdAt: Date!
    
    /// The MastodonAccount object that created this status
    var account: MastodonAccount!
    
    /// Content of status as HTML
    var content: String!
    
    /// The Visibility of this Status
    var visibility: StatusVisibility!
    
    /// Is this status marked as sensitive content?
    var sensitive: Bool!
    
    /// Description of content hidden behind spoiler/content warning
    var spoilerText: String!
    
    /// Media attached to this Status
    var mediaAttachments: [MastodonMediaAttachment]!
    
    /// Application a status was posted with
    var application: Application?
    
    /// Mentioned users in this Status
    var mentions: [Mention]!
    
    /// Tags attached to this Status
    var tags: [Tag]!
    
    /// Custom emojis used in this Status
    var emojis: [MastodonCustomEmoji]!
    
    /// Number of boosts this Status has received
    var reblogsCount: Int!
    
    /// Number of Favourites this Status has received
    var favouritesCount: Int!
    
    /// Number of replies this Status has received
    var repliesCount: Int!
    
    /// Location of the Statuses HTML representation. Optional
    var url: URL?
    
    /// Status ID this status is replying to. Optional
    var inReplyToId: Identifier?
    
    /// Account ID this status is replying to. Optional
    var inReplyToAccountId: MastodonAccountId?
    
    /// Status being reblogged. Optional
    var reblog: MastodonStatus?
    
    /// A Poll if attached. Otherwise `nil`
    var poll: MastodonPoll?
    
    /// Preview card for linked content. Optional
    var card: MastodonPreviewCard?
    
    /// Language of Status as ISO two-letter code. Optional
    var language: String?
    
    /// Plain text source of status. Optional
    var text: String?
    
    /// When the status was last edited. `nil` if not edited
    var editedAt: Date?
    
    /// Has the current user faved this Status? Optional
    var favourited: Bool?
    
    /// Has the current user reblogged this Status? Optional
    var reblogged: Bool?
    
    /// Has the current user muted notifications for this Status? Optional
    var muted: Bool?
    
    /// Has the current user bookmarked this Status? Optional
    var bookmarked: Bool?
    
    /// Has the current user pinned this Status? Optional
    var pinned: Bool?
    
    /// The current user's filter and keywords for this Status. Optional
    var filtered: [FilterResult]?
}

    
// MARK: - inner types
extension MastodonStatus
{
    typealias Identifier = String
    
    ///
    /// Application a status was posted with
    ///
    struct Application: Codable
    {
        var name: String
        var website: URL?
    }
    
    ///
    /// The visibility of a Mastodon Status
    ///
    enum StatusVisibility: String, Codable
    {
        /// Visible to everyone, shown in public timelines
        case `public` = "public"
        
        /// Visible to public, but not included in public timelines
        case unlisted = "unlisted"
        
        /// Visible to followers only, and to any mentioned users
        case `private` = "private"
        
        ///  Visible only to mentioned users
        case direct = "direct"
    }
    
    ///
    /// Mentioned User in a Status
    ///
    struct Mention: Codable, Equatable
    {
        /// Account ID of the mentioned user
        var id: MastodonAccountId
        
        /// Username of the mentioned user
        var username: String
        
        /// Location of mentioned user's profile
        var url: URL
        
        /// Webfinger account of mentioned user.
        /// `username` for local users, otherwise `username@domain`
        var acct: WebfingerAccount
    }
    
    ///
    /// Tag attached to a Status
    ///
    struct Tag: Codable, Equatable
    {
        /// Value of hashtag after `#` sign
        var name: String
        
        /// A link to this hashtag on the instance
        var url: URL
    }
    
    ///
    /// A filter whose keywords matched a given status
    ///
    struct FilterResult: Codable, Equatable
    {
        static func == (lhs: FilterResult, rhs: FilterResult) -> Bool
        {
            lhs.filter.id == rhs.filter.id
            && lhs.keywordMatches == rhs.keywordMatches
            && lhs.statusMatches == rhs.statusMatches
        }
        
        /// The filter that was matched
        var filter: MastodonFilter
        
        /// The keywords within the filter that were matched. Optional
        var keywordMatches: [String]?
        
        /// The status ID within the filter that was matched. Optional
        var statusMatches: [MastodonStatus.Identifier]?
    }
    
    ///
    /// The context of a Status in a Mastodon thread
    ///
    struct Context: Codable
    {
        /// The prior statuses in a thread
        var ancestors: [MastodonStatus]
        
        /// The later statuses in a thread
        var descendants: [MastodonStatus]
    }
}


// MARK: - Hashable conformance
extension MastodonStatus: Hashable, Equatable
{
    static func == (lhs: MastodonStatus, rhs: MastodonStatus) -> Bool 
    {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) 
    {
        hasher.combine(id)
    }
}

