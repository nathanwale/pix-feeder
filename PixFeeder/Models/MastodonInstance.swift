//
//  MastodonInstance.swift
//  Mastodon
//
//  Created by Nathan Wale on 1/11/2023.
//

import Foundation

///
/// A Mastodon Instance (or server)
///
struct MastodonInstance: Codable
{
    /// Domain name of the instance
    let domain: String
    
    /// Name of the instance
    let title: String
    
    /// Version of Mastodon installed
    let version: String
    
    /// Location of the source code for the software running this instance
    /// (This is a requirement of the AGPL license)
    let sourceUrl: URL
    
    /// Description of the instance
    let description: String
    
    /// Usage data for this Instance
    let usage: Usage
    
    /// Thumbnail image for this Instance
    let thumbnail: Thumbnail
    
    /// Primary languages of this Instance, as a list of two-letter codes
    let languages: [String]
    
    /// Configuration for this instance
    let configuration: MastodonInstanceConfiguration
    
    /// Registration information about this instance
    let registrations: Registrations
    
    /// Contact information for this instance
    let contact: Contact
    
    /// Rules for this instance
    let rules: [Rule]
}


// MARK: - inner types
extension MastodonInstance
{
    ///
    /// Usage data for an Instance
    ///
    struct Usage: Codable
    {
        /// User stats
        let users: Users
        
        /// User stats for an instance
        struct Users: Codable
        {
            /// Number of active users in the past 4 weeks
            let activeMonth: Int
        }
    }
    
    ///
    /// Thumbnail image for an Instance
    ///
    struct Thumbnail: Codable
    {
        /// Location of thumbnail image
        let url: URL
        
        /// Blurhash of thumbnail
        let blurhash: String?
        
        /// Different thumbnail resolutions
        let versions: Versions?
        
        /// Different thumbnail resolutions
        struct Versions: Codable
        {
            /// 1⨉ resolution
            let singleResolution: URL?
            
            /// 2⨉ resolution
            let doubleResolution: URL?
            
            enum CodingKeys: String, CodingKey
            {
                case singleResolution = "@1x"
                case doubleResolution = "@2x"
            }
        }
    }
    
    ///
    /// Info about registration for an Instance
    ///
    struct Registrations: Codable
    {
        /// Are registrations currently enabled?
        let enabled: Bool
        
        /// Is moderator approval required to register?
        let approvalRequired: Bool
        
        /// Message to be shown when registrations are closed
        let message: String?
        
        /// Undocumented `url` paramater. Optional
        let url: URL?
    }
    
    ///
    /// Contact information for an Instance
    ///
    struct Contact: Codable
    {
        /// Email address for this instance
        let email: String
        
        /// A Mastodon account that can be contacted about this instance
        let account: MastodonAccount
    }
    
    ///
    /// A Rule regarding an Instance
    ///
    struct Rule: Codable, Identifiable
    {
        /// Identifier
        let id: String
        
        /// Description of the rule
        let text: String
    }
}
