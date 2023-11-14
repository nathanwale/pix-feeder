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
    var request: any MastodonStatusRequest
    
    /// The Status
    var focusedStatus: MastodonStatus?
    
    /// Index of focused Status
    private var focusedStatusIndex: Int? {
        if let focusedStatus {
            statuses.firstIndex(of: focusedStatus)
        } else {
            nil
        }
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
    
    /// Newest Statis
    var newestStatus: MastodonStatus? {
        statuses.max { $0.id > $1.id }
    }
    
    /// Oldest Status
    var oldestStatus: MastodonStatus? {
        statuses.min { $0.id < $1.id }
    }
    
    // MARK: - methods
    /// Is this status focused?
    func isFocused(status: MastodonStatus) -> Bool
    {
        status == focusedStatus
    }
    
    /// Fetch or drop Statuses based on where we are in the feed.
    mutating func balance() async throws -> [MastodonStatus]
    {
        // index of current status, else zero
        let currentIndex = focusedStatusIndex ?? 0
        
        // conditions
        let shouldFetchOlder = currentIndex > (statuses.count - fetchThreshold)
        let shouldFetchNewer = currentIndex < fetchThreshold
        let shouldDropOlder = currentIndex < (statuses.count - dropThreshold)
        
        // fetch older statuses
        if shouldFetchOlder {
            statuses += try await fetchOlder()
        }
        
        // fetch newer statuses
        if shouldFetchNewer {
            statuses += try await fetchNewer()
        }
        
        // drop older statuses
        if shouldDropOlder {
            statuses = dropOld()
        }
        
        // sort newest first before returning
        return statuses.sorted { $0.createdAt > $1.createdAt }
    }
    
    /// Fetch older Statuses
    func fetchOlder() async throws -> [MastodonStatus]
    {
        if let lastStatusId = statuses.last?.id {
            print("Fetching statuses older than #\(lastStatusId)")
            return []
        } else {
            return try await fetchInitial()
        }
    }
    
    /// Fetch newer Statuses
    mutating func fetchNewer() async throws -> [MastodonStatus]
    {
        if let firstStatusId = statuses.first?.id,
           let newestStatus
        {
            print("Fetching statuses newer than #\(firstStatusId)")
            request.timeFrame = .before(newestStatus)
            return try await request.send()
        } else {
            return try await fetchInitial()
        }
    }
    
    /// Fetch initial batch of Statuses
    func fetchInitial() async throws -> [MastodonStatus]
    {
        print("Fetching initial batch of statuses")
        let newStatuses = try await request.send()
        print("...Fetched \(newStatuses.count) statuses")
        print(newStatuses.map { $0.account.displayName })
        return newStatuses
    }
    
    /// Drop old statuses
    func dropOld() -> [MastodonStatus]
    {
        print("dropping old indices")
        return statuses.dropLast(batchSize)
    }
}
