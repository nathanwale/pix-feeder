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
        
    /// What's the source of Statuses?
    /// - preloaded: A preloaded array of MastodonStatuses
    /// - online: A MastodonStatusRequest for fetching Statuses from online
    enum Source
    {
        case preloaded([MastodonStatus])
        case online(any MastodonStatusRequest)
    }
    
    /// The configured Source
    let source: Source
    
    /// Index of Status in the middle of the screen
    @State var middleStatusIdentifier: MastodonStatus.Identifier?
    
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
        source = .preloaded(statuses)
    }
    
    /// Initialise with API Request to fetch Statuses from online
    init(request: any MastodonStatusRequest)
    {
        source = .online(request)
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
                    // is this post in the middle?
                    .background {
                        // need to read the geometry to tell which post
                        // is in the middle of the screen
                        GeometryReader
                        {
                            geo in
                            let bgColour = status.id == middleStatusIdentifier
                                ? Color.teal.opacity(0.1)
                                : Color.clear
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
                                        middleStatusIdentifier = status.id
                                    }
                                }
                        }
                    }
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
                statuses = await loadSource()
            }
        }
    }
    
    /// Load source of Statuses.
    /// If online, will send API request
    /// Otherwise will immediately return the preloaded Statuses
    func loadSource() async -> [MastodonStatus]
    {
        switch source {
            case .preloaded(let array):
                return array
            case .online(let request):
                do {
                    return try await request.send()
                } catch {
                    print(error)
                    return []
                }
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
