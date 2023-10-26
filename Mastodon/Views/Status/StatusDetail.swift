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
    @Namespace var currentStatusId
    
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
        ScrollViewReader
        {
            scrollProxy in
            ScrollView
            {
                VStack
                {
                    statusList(ancestors)
                    indicator("Prior", icon: .chevronUp)
                    StatusPost(status)
                        .background(Color.accentColor.opacity(0.1))
                        .id(currentStatusId)
                        .padding(0)
                    indicator("Replies", icon: .chevronDown)
                    statusList(descendants)
                }
                .navigationTitle("Post by \(status.account.displayName)")
                .onAppear {
                    scrollProxy.scrollTo(currentStatusId, anchor: .top)
                }
            }
        }
    }
    
    func indicator(_ text: String, icon: Icon) -> some View
    {
        HStack
        {
            Spacer()
            icon.image
            Text(text).font(.headline)
                .padding(5)
            icon.image
            Spacer()
        }
        .foregroundColor(.white)
        .background(Color.secondary)
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
}
