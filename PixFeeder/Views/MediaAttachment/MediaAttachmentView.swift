//
//  MediaAttachment.swift
//  Mastodon
//
//  Created by Nathan Wale on 21/9/2023.
//

import SwiftUI

struct MediaAttachmentView: View
{
    var attachment: PixelfedMediaAttachment
    
    @State private var showFullDescription = false
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            attachmentView
            description
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
    
    /// Description, if present
    @ViewBuilder
    var description: some View
    {
        if let text = attachment.description,
           text != ""
        {
            ExpandableText(text)
                .padding(5)
                .background(Color.black)
                .foregroundColor(.white)
        }
    }
}

struct MediaAttachment_Previews: PreviewProvider {
    static var previews: some View {
        MediaAttachmentView(attachment: .previewImageAttachment)
    }
}
