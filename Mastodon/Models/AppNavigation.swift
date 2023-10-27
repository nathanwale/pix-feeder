//
//  AppNavigation.swift
//  Mastodon
//
//  Created by Nathan Wale on 26/10/2023.
//

import Foundation

///
/// Represents the state of navigation in the App.
/// Navigation can be persisted across sessions.
///
final class AppNavigation: ObservableObject, Codable
{
    /// The navigation path as a list of Statuses
    @Published var path: [MastodonStatus]
    
    /// Coding keys for persistence
    enum CodingKeys: String, CodingKey
    {
        case navigationPath
    }
    
    /// Init with empty path
    init()
    {
        path = []
    }
        
    /// Decode from persisted object
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        path = try container.decode([MastodonStatus].self, forKey: CodingKeys.navigationPath)
    }
    
    /// Encode into persisted object
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: CodingKeys.navigationPath)
    }
}
