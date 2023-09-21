//
//  PreviewModels.swift
//  Mastodon
//
//  Created by Nathan Wale on 19/9/2023.
//

import Foundation

extension JsonLoader
{
    /// Load JSON data from preview folder.
    /// - filename: name of file without extension
    ///
    static func fromSample<T: Decodable>(_ filename: String) -> T
    {
        let fileUrl = Bundle.main.url(forResource: filename, withExtension: "json")!
        return JsonLoader.fromLocalUrl(fileUrl)
    }
}

extension MastodonStatus
{
    /// Sample Statuses for previews
    static var previews: [MastodonStatus] {
        return JsonLoader.fromSample("multiple-statuses")
    }
    
    /// Sample Status for previews
    static var preview: MastodonStatus {
        return previews[0]
    }
}


extension MastodonMediaAttachment
{
    /// Sample Attachments for previews
    static var previews: [MastodonMediaAttachment] {
        return JsonLoader.fromSample("multiple-attachments")
    }
    
    /// Sample Image Attachment for previews
    static var previewImageAttachment: MastodonMediaAttachment {
        return previews[0]
    }
}
