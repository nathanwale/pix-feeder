//
//  TestNavStackView.swift
//  PixFeeder
//
//  Created by Nathan Wale on 3/10/2023.
//

import SwiftUI

struct TestNavStackView: View 
{
    let imageUrls: [URL]
    
    struct Row: View {
        let url: URL
        var body: some View {
            VStack
            {
                WebImage(url: url)
                Text(url.description)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    var body: some View
    {
        NavigationStack
        {
            List(imageUrls, id: \.description)
            {
                url in
                Row(url: url)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    let urlStrings = [
        "https://files.mastodon.social/cache/media_attachments/files/110/878/019/449/737/389/original/7f141d36728d03a8.jpg",
        "https://files.mastodon.social/media_attachments/files/111/168/922/529/397/433/original/46567fceddb46a17.jpeg",
        "https://files.mastodon.social/cache/media_attachments/files/111/168/922/444/423/380/original/8c0af2f568b03594.jpeg",
        "https://files.mastodon.social/cache/media_attachments/files/111/168/922/014/912/318/original/3a309807d129c379.png",
        "https://files.mastodon.social/cache/media_attachments/files/111/168/921/731/919/819/original/cd84bb3898e9cee8.jpg",
        "https://files.mastodon.social/cache/media_attachments/files/111/134/751/851/359/262/original/3cfd2a1197bf907d.jpg",
    ]
    
    let urls = urlStrings.map { URL(string: $0)! }
    
    return TestNavStackView(imageUrls: urls)
}
