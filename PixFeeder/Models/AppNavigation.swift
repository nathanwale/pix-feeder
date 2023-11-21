//
//  AppNavigation.swift
//  Mastodon
//
//  Created by Nathan Wale on 26/10/2023.
//

import Foundation
import SwiftUI

///
/// Represents the state of navigation in the App.
/// Navigation can be persisted across sessions.
///
final class AppNavigation: ObservableObject, Codable
{
    /// The navigation path as a list of Statuses
    @Published var path: NavigationPath
    
    /// Coding keys for persistence
    enum CodingKeys: String, CodingKey
    {
        case navigationPath
    }
    
    /// Init with empty path
    init()
    {
        path = NavigationPath()
    }
        
    /// Decode from persisted object
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let codableRepresentation = try container.decode(NavigationPath.CodableRepresentation.self, forKey: CodingKeys.navigationPath)
        path = NavigationPath(codableRepresentation)
    }
    
    /// Encode into persisted object
    func encode(to encoder: Encoder) throws
    {
        // get codable representation
        guard let representation = path.codable else {
            return
        }
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(representation, forKey: CodingKeys.navigationPath)
    }
    
    /// Push a new navigation item onto the Navigation Path
    func push(_ navigationItem: any Hashable)
    {
        path.append(navigationItem)
    }
}
