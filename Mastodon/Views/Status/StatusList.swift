//
//  StatusList.swift
//  Mastodon
//
//  Created by Nathan Wale on 27/9/2023.
//

import SwiftUI

///
/// The default list of statuses, navigable to view replies, etc.
///
struct StatusList: View
{
    /// Statuses to display
    @State var statuses = [MastodonStatus]()
    
    /// Request for fetching Statuses
    var request: (any MastodonStatusRequest)?
    
    /// Focused Status
    @State var focusedStatus: MastodonStatus?
    
    /// App Navigation
    @EnvironmentObject private var navigation: AppNavigation
    
    /// Insets for Status Posts
    let statusInsets = EdgeInsets(
        top: 10,
        leading: 0,
        bottom: 20,
        trailing: 0
    )
    
    /// Initialise with preloaded list of statuses
    init(_ statuses: [MastodonStatus])
    {
        _statuses = .init(initialValue: statuses)
    }
    
    /// Initialise with API Request to fetch Statuses from online
    init(request: any MastodonStatusRequest)
    {
        self.request = request
    }
    
    /// Body
    var body: some View
    {
        NavigationStack(path: $navigation.path)
        {
            List(statuses)
            {
                status in
                
                // Show status
                StatusPost(status)
                    .listRowSeparator(.hidden)
                    .listRowInsets(statusInsets)
                    // colour and event to update focused status
                    .background(background(status: status))
            }
            // List styling
            .listStyle(.plain)
            .buttonStyle(.borderless)
            // Pass on navigation object
            .environmentObject(navigation)
            // Configure navigation
            .navigationDestination(for: MastodonStatus.self) {
                status in
                StatusDetail(status)
            }
            // Load source of Statuses
            .task {
                await loadStatusesIfRequired()
            }
        }
    }
    
    /// background colour and event to update focused status
    func background(status: MastodonStatus) -> some View
    {
        // need to read the geometry to tell which post
        // is in the middle of the screen
        GeometryReader
        {
            geo in
            
            // background colour for focused status
            let bgColour = (status == focusedStatus)
                ? Color.teal.opacity(0.1)
                : Color.clear
            
            // assign colour and set up event
            Color(bgColour)
                .onChange(of: geo.frame(in: .global).midY)
            {
                let midY = geo.frame(in: .global).midY
                let screenHeight = UIScreen.main.bounds.height
                let screenMidY = screenHeight / 2
                let threshold: CGFloat = screenHeight / 10
                let isInMiddle = (midY > screenMidY - threshold)
                && (midY < screenMidY + threshold)
                if isInMiddle {
                    focusedStatus = status
                }
            }
        }
    }
    
    /// Load Statuses if required
    func loadStatusesIfRequired() async
    {
        if let request {
            var source = StatusSource(statuses: statuses, request: request)
            do {
                statuses = try await source.balance()
            } catch {
                print(error)
            }
        } else {
            print("no request object to send")
        }
    }
}


// MARK: - previews

#Preview("Sample posts") {
    StatusList(MastodonStatus.previews)
        .environmentObject(AppNavigation())
}

#Preview("Online user posts")
{
    StatusList(request: UserTimelineRequest.sample)
        .environmentObject(AppNavigation())
}

#Preview("Online public timeline")
{
    StatusList(request: PublicTimelineRequest.sample)
        .environmentObject(AppNavigation())
}

#Preview("Isolated post") {
    StatusList(MastodonStatus.previews.filter { $0.id == "110879987501995566"})
        .environmentObject(AppNavigation())
}
