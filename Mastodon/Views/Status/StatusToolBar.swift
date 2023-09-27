//
//  StatusToolBar.swift
//  Mastodon
//
//  Created by Nathan Wale on 26/9/2023.
//

import SwiftUI

struct StatusToolBar: View 
{
    let status: MastodonStatus
    
    var body: some View
    {
        let actionsWithCounts = [
            ("Show replies", Icon.replies, showReplies, status.repliesCount),
            ("Reblog", Icon.reblog, reblogStatus, status.reblogsCount),
            ("Favourite", Icon.favourite, favouriteStatus, status.favouritesCount),
        ]
        
        HStack
        {
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
            Button("Share", systemImage: Icon.share.rawValue, action: shareStatus)
            Divider()
            Spacer()
            Button("Reply", systemImage: Icon.reply.rawValue, action: replyToStatus)
                .labelStyle(.titleAndIcon)
        }
        .labelStyle(.iconOnly)
    }
    
    struct ButtonWithCount: View
    {
        let label: String
        let icon: Icon
        let count: Int
        let action: () -> Void
        
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
        print("Showing replies...")
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

#Preview("Status tool bar", traits: .fixedLayout(width: 400, height: 50)) {
    StatusToolBar(status: MastodonStatus.preview)
        .padding(20)
}
