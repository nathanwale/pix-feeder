//
//  ImageAttachment.swift
//  Mastodon
//
//  Created by Nathan Wale on 21/9/2023.
//

import SwiftUI

struct ImageAttachment: View
{
    var attachment: MastodonMediaAttachment
    var body: some View
    {
        WebImage(url: attachment.url)
    }
}

struct ImageAttachment_Previews: PreviewProvider {
    static var previews: some View {
        ImageAttachment(attachment: MastodonMediaAttachment.previewImageAttachment)
    }
}
