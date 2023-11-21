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
class StatusSource: ObservableObject
{
    /// The Statuses that have already been loaded
    @Published var statuses: [MastodonStatus]
    
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
    
    init(statuses: [MastodonStatus], request: any MastodonStatusRequest)
    {
        self.statuses = statuses
        self.request = request
    }
    
    // MARK: - methods
    /// Is this status focused?
    func isFocused(status: MastodonStatus) -> Bool
    {
        status == focusedStatus
    }
    
    /// Fetch or drop Statuses based on where we are in the feed.
    func balance() async throws
    {
        // index of current status, else zero
        let currentIndex = focusedStatusIndex ?? 0
        
        // conditions
        print(
            "Current index:", currentIndex,
            "Statuses count:", statuses.count,
            "Fetch threshold:", fetchThreshold,
            "Drop threshold:", dropThreshold
        )
        
        let shouldFetchOlder = currentIndex > (statuses.count - fetchThreshold)
        let shouldDropOlder = currentIndex < (statuses.count - dropThreshold)
        
        // fetch older statuses
        if shouldFetchOlder {
            statuses += try await fetchOlder()
        }
        
        // drop older statuses
        if shouldDropOlder {
            dropOld()
        }
        
        // sort newest first before returning
        statuses.sort { $0.createdAt > $1.createdAt }
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
    func subscribeToNew() async throws -> [MastodonStatus]
    {
        if let newestStatus
        {
            print("Fetching statuses newer than #\(newestStatus.id!), by \(newestStatus.account.displayName ?? "<<unknown>>")")
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
    func dropOld()
    {
        print("dropping old indices")
        statuses.removeLast(batchSize)
    }
}
