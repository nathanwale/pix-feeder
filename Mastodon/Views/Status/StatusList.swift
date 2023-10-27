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
    
    @State private var path = NavigationPath()
    
    /// Initialise with list of statuses
    init(_ statuses: [MastodonStatus]) {
        self.statuses = statuses
    }
    
    /// Body
    var body: some View
    {
        NavigationStack(path: $path)
        {
            List(statuses)
            {
                let insets = EdgeInsets(
                    top: 10,
                    leading: 0,
                    bottom: 20,
                    trailing: 0
                )
                
                StatusPost($0)
                    .listRowSeparator(.hidden)
                    .listRowInsets(insets)
            }
            .listStyle(.plain)
        }
    }
}


// MARK: - previews

#Preview("Many posts") {
    StatusList(MastodonStatus.previews)
}

#Preview("Isolated post") {
    StatusList(MastodonStatus.previews.filter { $0.id == "110879987501995566"})
}
