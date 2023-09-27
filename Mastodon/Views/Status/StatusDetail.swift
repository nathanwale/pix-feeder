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
    
    init(_ status: MastodonStatus)
    {
        self.status = status
    }
    
    var body: some View 
    {
        VStack
        {
            StatusPost(status)
            Text("All the replies...")
            Spacer()
        }
        .navigationTitle("Post by \(status.account.displayName)")
    }
}

#Preview 
{
    StatusDetail(MastodonStatus.preview)
        .padding(20)
}
