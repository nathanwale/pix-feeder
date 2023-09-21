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
    static var samples: [MastodonStatus] {
        return JsonLoader.fromSample("multiple-statuses")
    }
    
    /// Sample Status for previews
    static var sample: MastodonStatus {
        return samples[0]
    }
}