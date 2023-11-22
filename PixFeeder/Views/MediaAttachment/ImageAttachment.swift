//
//  ImageAttachment.swift
//  PixFeeder
//
//  Created by Nathan Wale on 21/9/2023.
//

import SwiftUI

struct ImageAttachment: View
{
    var attachment: PixelfedMediaAttachment
    var body: some View
    {
        WebImage(url: attachment.url)
    }
}

struct ImageAttachment_Previews: PreviewProvider {
    static var previews: some View {
        ImageAttachment(attachment: PixelfedMediaAttachment.previewImageAttachment)
    }
}
