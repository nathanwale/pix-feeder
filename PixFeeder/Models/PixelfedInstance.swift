//
//  PixelfedInstance.swift
//  PixFeeder
//
//  Created by Nathan Wale on 1/11/2023.
//

import Foundation

///
/// A Pixelfed (or Mastodon) Instance (or server)
///
struct PixelfedInstance: Codable
{
    /// URI of the instance
    let uri: URL
    
    /// Name of the instance
    let title: String
    
    /// Version of Pixelfed installed
    let version: String
    
    /// Description of the instance
    let description: String
    
    /// Short description of the instance
    let shortDescription: String
        
    /// Thumbnail image for this Instance
    let thumbnail: URL
    
    /// Primary languages of this Instance, as a list of two-letter codes
    let languages: [String]
    
    /// Configuration for this instance
    let configuration: PixelfedInstanceConfiguration
    
    /// Are registrations open for this instance?
    let registrations: Bool
    
    /// Is moderator approval required to register?
    let approvalRequired: Bool
    
    /// Contact acount for this instance
    let contactAccount: PixelfedAccount
    
    /// Email address for this instance
    let email: String
    
    /// Rules for this instance
    let rules: [Rule]
}


// MARK: - inner types
extension PixelfedInstance
{
    ///
    /// Usage data for an Instance
    /// *This is in V2 of mastodon, but not V1 that Pixelfed uses*
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
    /// *This is in V2 of mastodon, but not V1 that Pixelfed uses*
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
    /// *This is in V2 of mastodon, but not V1 that Pixelfed uses*
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
    /// *This is in V2 of mastodon, but not V1 that Pixelfed uses*
    ///
    struct Contact: Codable
    {
        /// Email address for this instance
        let email: String
        
        /// A Pixelfed account that can be contacted about this instance
        let account: PixelfedAccount
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
