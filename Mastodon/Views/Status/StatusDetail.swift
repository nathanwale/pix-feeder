//
//  StatusDetail.swift
//  Mastodon
//
//  Created by Nathan Wale on 27/9/2023.
//

import SwiftUI

struct StatusDetail: View 
{
    let status: MastodonStatus
    let context: MastodonStatus.Context?
    
    var ancestors: [MastodonStatus]
    {
        context?.ancestors ?? []
    }
    
    var descendants: [MastodonStatus]
    {
        context?.descendants ?? []
    }
    
    init(_ status: MastodonStatus, context: MastodonStatus.Context? = nil)
    {
        self.status = status
        self.context = context
    }
        
    var body: some View 
    {
        ScrollView
        {
            VStack
            {
                statusList(ancestors)
                StatusPost(status)
                    .background(Color.accentColor.opacity(0.1))
                Text("Replies").font(.headline)
                statusList(descendants)
            }
            .navigationTitle("Post by \(status.account.displayName)")
        }
    }
    
    func statusList(_ statuses: [MastodonStatus]) -> some View
    {
        VStack
        {
            ForEach(statuses)
            {
                StatusPost($0)
            }
        }
    }
}

#Preview 
{
    StatusDetail(
        MastodonStatus.preview,
        context: MastodonStatus.previewContext
    )
    .padding(20)
}
