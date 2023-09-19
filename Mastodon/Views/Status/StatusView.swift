//
//  StatusView.swift
//  Mastodon
//
//  Created by Nathan Wale on 19/9/2023.
//

import SwiftUI

struct StatusView: View
{
    /// The post to be shown
    var status: MastodonStatus
    
    /// Account that posted this status
    var account: MastodonAccount {
        status.account
    }
    
    var body: some View
    {
        VStack
        {
            profileStack
            content
        }
    }
    
    /// Profile image
    var profileImage: some View
    {
        ProfileImage(url: account.avatar)
    }
    
    /// Profile features
    var profileStack: some View
    {
        HStack
        {
            profileImage
            VStack(alignment: .leading)
            {
                Text(account.displayName)
                    .font(.title)
                HStack
                {
                    Text("@" + account.acct)
                }
            }
        }
    }
    
    /// Content of post
    var content: some View
    {
        HtmlView(html: status.content)
    }
}

struct StatusView_Previews: PreviewProvider
{
    static var previews: some View
    {
        StatusView(status: MastodonStatus.samples[1])
    }
}
