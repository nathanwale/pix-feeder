//
//  MastodonCustomEmoji.swift
//  Mastodon
//
//  Created by Nathan Wale on 7/9/2023.
//

import Foundation

/**
    A custom emoji
        - Decoded from API as described at: https://docs.joinmastodon.org/entities/CustomEmoji/
 */
struct PixelfedCustomEmoji: Codable, Equatable
{
    /// The name of the emoji as referenced in posts
    let shortcode: String?
    
    /// Location of emoji image (may be animated)
    let url: URL
    
    /// Location of non-animated version of emoji image
    let staticUrl: URL
    
    /// Is this emoji visible in the picker? Otherwise it's unlisted
    let visibleInPicker: Bool?
    
    /// Category of emoji for organising in picker
    let category: String?
}
