//
//  StatusToolBar.swift
//  Mastodon
//
//  Created by Nathan Wale on 26/9/2023.
//

import SwiftUI

///
/// Allows user interaction with a Status
///
struct StatusToolBar: View
{
    /// The status this toolbar belongs to
    let status: MastodonStatus
    
    /// Navigation object
    @EnvironmentObject private var navigation: AppNavigation
    
    /// Body view
    var body: some View
    {
        // Actions that have status counts associated with them
        let actionsWithCounts = [
            ("Show replies", Icon.replies, showReplies, status.repliesCount),
            ("Reblog", Icon.reblog, reblogStatus, status.reblogsCount),
            ("Favourite", Icon.favourite, favouriteStatus, status.favouritesCount),
        ]
        
        // Button stack
        HStack
        {
            // Buttons with counts (comment, boost, fave)
            ForEach(actionsWithCounts, id: \.0)
            {
                (label, icon, action, count) in
                ButtonWithCount(
                    label: label,
                    icon: icon,
                    count: count ?? 0,
                    action: action)
            }
            Spacer()
            Divider()
            // Share button
            Button("Share", systemImage: Icon.share.rawValue, action: shareStatus)
            Divider()
            Spacer()
            // Reply button
            Button("Reply", systemImage: Icon.reply.rawValue, action: replyToStatus)
                .labelStyle(.titleAndIcon)
        }
        .labelStyle(.iconOnly)
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(Color(uiColor: .tertiarySystemFill))
        .fixedSize(horizontal: false, vertical: true)
    }
    
    /// A button with a count (eg. replies)
    struct ButtonWithCount: View
    {
        /// Button label. May not be shown
        let label: String
        
        /// Icon to display. May not be shount
        let icon: Icon
        
        /// Count to show next to button
        let count: Int
        
        /// Action called on button tap
        let action: () -> Void
        
        /// Body view
        var body: some View
        {
            Button(label, systemImage: icon.rawValue, action: action)
            Text(count.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.leading, -5)
                .padding(.trailing, 10)
        }
    }
}
 

// MARK: - actions
extension StatusToolBar
{
    /// Show replies for this status
    func showReplies()
    {
        navigation.push(status)
        print("Showing \(status.repliesCount ?? 0) replies...")
    }
    
    /// Reply to this status
    func replyToStatus() -> Void
    {
        print("Replying to status...")
    }
    
    /// Reblog this status
    func reblogStatus() -> Void
    {
        print("Reblogging status...")
    }
    
    /// Favourite this status
    func favouriteStatus() -> Void
    {
        print("Favouriting status...")
    }
    
    /// Share this status
    func shareStatus() -> Void
    {
        print("Sharing status...")
    }
}


// MARK: - previews
#Preview("Status tool bar", traits: .fixedLayout(width: 400, height: 50)) {
    StatusToolBar(status: MastodonStatus.preview)
        .padding(20)
        .environmentObject(AppNavigation())
}
