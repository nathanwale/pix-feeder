//
//  MediaAttachment.swift
//  Mastodon
//
//  Created by Nathan Wale on 21/9/2023.
//

import SwiftUI

struct MediaAttachmentView: View
{
    var attachment: MastodonMediaAttachment
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            attachmentView
            tools
        }
    }
    
    /// Display attachment
    @ViewBuilder
    var attachmentView: some View
    {
        switch attachment.type
        {
            case .image:
                ImageAttachment(attachment: attachment)
            case .audio:
                Text("Audio attachment")
            case .gifv:
                Text("Gif attachment")
            case .video:
                Text("Video attachment")
            case .unknown:
                Text("Unknown attachment")
                
        }
    }
    
    ///
    var tools: some View
    {
        VStack(alignment: .trailing)
        {
            HStack
            {
                Spacer()
                Icon.altText.image
            }
            .padding(5)
        }
        .background(Color.primary)
        .foregroundColor(.white)
    }
}

struct MediaAttachment_Previews: PreviewProvider {
    static var previews: some View {
        MediaAttachmentView(attachment: .previewImageAttachment)
    }
}
