//
//  ProfileImage.swift
//  PixFeeder
//
//  Created by Nathan Wale on 19/9/2023.
//

import SwiftUI

struct ProfileImage: View
{
    var url: URL?
    
    var size = Size.status
    
    var body: some View
    {
        WebImage(url: url)
            .frame(width: size.rawValue, height: size.rawValue)
            .cornerRadius(5)
    }
    
    enum Size: CGFloat
    {
        case feature = 100.0
        case status = 50.0
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "https://files.mastodon.social/accounts/avatars/110/528/637/375/951/012/original/2d14c64b7a9e1f10.jpeg")!
        VStack {
            ProfileImage(url: url, size: .status)
            Text("Status size")
            ProfileImage(url: url, size: .feature)
            Text("Feature size")
        }
    }
}
