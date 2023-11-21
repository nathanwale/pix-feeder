//
//  MastodonCustomEmoji.swift
//  Mastodon
//
//  Created by Nathan Wale on 7/9/2023.
//

import Foundation


typealias PixelfedPollId = String

/**
    A Pixelfed (or Mastodon) poll
        - Decoded from API as described at: https://docs.joinmastodon.org/entities/Poll/
 */
struct PixelfedPoll: Codable
{
    /// Identifier of this poll
    var id: PixelfedPollId
    
    /// When the poll ends. Optional
    var expiresAt: Date?
    
    /// Has this poll expired?
    var expired: Bool
    
    /// Does the poll allow multiple choices?
    var multiple: Bool
    
    /// How many votes have been received
    var votesCount: Int
    
    /// How many unique accounts have voted on a multi-choice poll
    /// Nil if this poll isn't multi-choice
    var votersCount: Int?
    
    /// The choices for this poll
    var options: [Options]
    
    /// Custom emojis used for rendering this poll
    var emojis: [PixelfedCustomEmoji]
    
    /// When called with a user token: has this user voted?
    /// Otherwise nil
    var voted: Bool?
    
    /// When called with a user token: what options has this user chosen,
    /// represented by index values for `options`. Optional
    var ownVotes: [Int]?
}


/// MARK: - inner types
extension PixelfedPoll
{
    struct Options: Codable, Equatable
    {
        /// Text value of this option
        var title: String
        
        /// Votes received for this option
        /// Nil if results haven't been published
        var votesCount: Int?
    }
    
}
