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
    case reblog = "arrow.uturn.up.circle.fill"
    case altText = "text.viewfinder"
}

///
extension Icon
{
    /// Icon as SwiftUI Image
    var image: some View {
        Image(systemName: self.rawValue)
    }
}
