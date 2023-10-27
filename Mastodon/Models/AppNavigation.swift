//
//  AppNavigation.swift
//  Mastodon
//
//  Created by Nathan Wale on 26/10/2023.
//

import Foundation

final class AppNavigation: ObservableObject, Codable
{
    @Published var path: [MastodonStatus]
    
    enum CodingKeys: String, CodingKey
    {
        case navigationPath
    }
    
    init()
    {
        path = []
    }
        
    required init(from decoder: Decoder) throws 
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        path = try container.decode([MastodonStatus].self, forKey: CodingKeys.navigationPath)
    }
    
    func encode(to encoder: Encoder) throws 
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: CodingKeys.navigationPath)
    }
}
