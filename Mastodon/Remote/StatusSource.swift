//
//  StatusSource.swift
//  Mastodon
//
//  Created by Nathan Wale on 8/11/2023.
//

import Foundation

///
/// A self-managing source of Statuses
///
struct StatusSource
{
    /// The Statuses that have already been loaded
    var statuses: [MastodonStatus]
    
    /// An API request object for fetching statuses
    var request: (any MastodonStatusRequest)?
    
    /// The Status
    var focusedStatus: MastodonStatus {
        didSet {
            balance()
        }
    }
    
    /// Index of focused Status
    var focusedStatusIndex: Int? {
        statuses.firstIndex(of: focusedStatus)
    }
    
    /// How many Statuses are newer in the timeline than the focused Status?
    var newerCount: Int {
        focusedStatusIndex ?? 0
    }
    
    /// How many Statuses to request from server at a time
    var batchSize = 20
    
    /// Fetch
    var fetchThreshold: Int {
        batchSize
    }
    
    /// Drop any Statuses that are
    var dropThreshold: Int {
        batchSize * 2
    }
    
    /// Fetch or drop Statuses based on where we are in the feed.
    func balance()
    {
        // index of current status, else zero
        let currentIndex = focusedStatusIndex ?? 0
        
        // conditions
        let shouldFetchOlder = currentIndex > (statuses.count - fetchThreshold)
        let shouldFetchNewer = currentIndex < fetchThreshold
        let shouldDropOlder = currentIndex < (statuses.count - dropThreshold)
        
        // fetch older statuses
        if shouldFetchOlder {
            fetchOlder()
        }
        
        // fetch newer statuses
        if shouldFetchNewer {
            fetchNewer()
        }
    }
    
    /// Fetch older Statuses
    func fetchOlder()
    {
        if let lastStatusId = statuses.last?.id {
            print("Fetching statuses older than #\(lastStatusId)")
        } else {
            fetchInitial()
        }
    }
    
    /// Fetch newer Statuses
    func fetchNewer()
    {
        if let firstStatusId = statuses.first?.id {
            print("Fetching statuses newer than #\(firstStatusId)")
        } else {
            fetchInitial()
        }
    }
    
    /// Fetch initial batch of Statuses
    func fetchInitial()
    {
        print("Fetching initial batch of statuses")
    }
    
    /// Drop old statuses
    mutating func dropOld()
    {
        statuses.removeLast(batchSize)
        print("dropping old indices")
    }
}
