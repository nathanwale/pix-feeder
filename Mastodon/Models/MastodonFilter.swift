//
//  MastodonFilter.swift
//  Mastodon
//
//  Created by Nathan Wale on 17/9/2023.
//

import Foundation


struct MastodonFilter: Codable
{
    /// ID of filter
    var id: Identifier
    
    /// User-given title for filter
    var title: String
    
    /// The context in which a filter can be applied
    var context: Context
    
    /// When the filter should expire. Otherwise `nil`
    var expiresAt: Date?
    
    /// The action to be taken when a status matches this filter
    var filterAction: Action
    
    /// The keywords grouped under this filter
    var keywords: [Keyword]
    
    /// The Statuses grouped under this filter
    var statuses: [Status]
}


// MARK: - inner types
extension MastodonFilter
{
    typealias Identifier = String
    
    /// The contexts in which a filter can be applied
    enum Context: Codable
    {
        /// home timeline and lists
        case home
        
        /// notifications timeline
        case notifications
        
        /// public timelines
        case `public`
        
        /// expanded thread of a detailed status
        case thread
        
        /// when viewing a profile
        case account
    }
    
    /// The action to be taken when a status matches this filter
    enum Action: Codable
    {
        /// Show a warning that identifies the matching filter by title, and allow the user to expand the filtered status.
        /// This is the default (and unknown values should be treated as equivalent to warn).
        case warn
        
        /// Do not show this status if it is received
        case hide
    }
    
    /// A keyword, that if matched, should cause a filter Action
    struct Keyword: Codable, Equatable
    {
        typealias Identifier = String
        
        /// ID of keyword
        var id: Identifier
        
        /// The phrase to be matched against
        var keyword: String
        
        /// Should the filter match word boundaries?
        var wholeWord: Bool
    }
    
    /// A status ID that a filter action should be taken on
    struct Status: Codable, Equatable
    {
        typealias Identifier = String
        
        /// ID of Filter Status
        var id: Identifier
        
        /// The ID of the Status that will be filtered
        var statusId: MastodonStatus.Identifier
    }
}
