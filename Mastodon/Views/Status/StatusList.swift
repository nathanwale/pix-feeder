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
    let statuses: [MastodonStatus]
    
    /// App Navigation
    @EnvironmentObject private var navigation: AppNavigation
    
    /// Initialise with list of statuses
    init(_ statuses: [MastodonStatus]) {
        self.statuses = statuses
    }
    
    /// Body
    var body: some View
    {
        NavigationStack(path: $navigation.path)
        {
            List(statuses)
            {
                status in
                
                // insets for post
                let insets = EdgeInsets(
                    top: 10,
                    leading: 0,
                    bottom: 20,
                    trailing: 0
                )
                
                // Show status
                StatusPost(status)
                    .listRowSeparator(.hidden)
                    .listRowInsets(insets)
            }
            .listStyle(.plain)
            .buttonStyle(.borderless)
            .environmentObject(navigation)
            .navigationDestination(for: MastodonStatus.self) {
                status in
                StatusDetail(status)
            }
        }
    }
}


// MARK: - previews

#Preview("Many posts") {
    StatusList(MastodonStatus.previews)
        .environmentObject(AppNavigation())
}

#Preview("Isolated post") {
    StatusList(MastodonStatus.previews.filter { $0.id == "110879987501995566"})
        .environmentObject(AppNavigation())
}
