//
//  SwiftUIView.swift
//  Mastodon
//
//  Created by Nathan Wale on 21/9/2023.
//

import SwiftUI

///
/// Common icons for use in UI
///
enum Icon: String
{
    case reblog = "arrow.uturn.up.circle"
    case altText = "text.bubble.fill"
    case showText = "text.magnifyingglass"
    case replies = "bubble.left.and.bubble.right"
    case reply = "plus.bubble"
    case favourite = "star"
    case share = "square.and.arrow.up"
}

// Icon extensions
extension Icon
{
    /// Icon as SwiftUI Image
    var image: some View {
        Image(systemName: self.rawValue)
    }
    
    /// Icon as ImageResource
    var resource: ImageResource {
        ImageResource(name: rawValue, bundle: Bundle.main)
    }
}
