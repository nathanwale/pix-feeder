//
//  PixelfedInstanceConfiguration.swift
//  PixFeeder
//
//  Created by Nathan Wale on 1/11/2023.
//

import Foundation

///
/// Configuration of an Instance
///
struct PixelfedInstanceConfiguration: Codable
{
    /// Limits relating to authoring Statuses
    let statuses: StatusPolicy
    
    /// Hints and limits for which Media Attachments an instance will accept
    let mediaAttachments: MediaAttachmentPolicy
    
    /// Limits relating to Polls on an Instance
    let polls: PollPolicy

}


// MARK: - inner types
extension PixelfedInstanceConfiguration
{
    /// URLs of interest for client apps
    struct Urls: Codable
    {
        /// Status. Not described in docs. Optional? Who knows.
        let status: URL?
        
        /// Websockets url for connecting to the streaming API. Optional
        let streaming: URL?
        
        /// Alias for `streaming` as described in docs. Optional
        let streamingApi: URL?
    }
    
    /// Limits relating to accounts
    struct AccountPolicy: Codable
    {
        /// The maximum number of featured tags allowed for each account.
        let maxFeaturedTags: Int
    }
    
    /// Limits relating to authoring Statuses
    struct StatusPolicy: Codable
    {
        /// Maximum allowed characters per Status
        let maxCharacters: Int
        
        /// Maximum allowed media attachments per Status
        let maxMediaAttachments: Int
        
        /// Each URL will be worth this many characters in a Status
        let charactersReservedPerUrl: Int
    }
    
    /// Hints and limits for which Media Attachments an instance will accept
    struct MediaAttachmentPolicy: Codable
    {
        /// Supported MIME types
        let supportedMimeTypes: [String]
        
        /// Maximum size of uploaded images (in bytes)
        let imageSizeLimit: Int
        
        /// Maximum total pixels (width times height) of uploaded images
        let imageMatrixLimit: Int
        
        /// Maximum size of uploaded videos (in bytes)
        let videoSizeLimit: Int
        
        /// Maximum framerate of uploaded videos
        let videoFrameRateLimit: Int
        
        /// Maximum total pixels (width times height of a frame) of uploaded videos
        let videoMatrixLimit: Int
    }
    
    /// Limits relating to Polls on an Instance
    struct PollPolicy: Codable
    {
        /// Maximum number of options allowed for polls
        let maxOptions: Int
        
        /// Maximum characters allowed for each option
        let maxCharactersPerOption: Int
        
        /// Shortest allowed Poll duration, in seconds
        let minExpiration: Int
        
        /// Longest allowed Poll duration, in seconds
        let maxExpiration: Int
    }
    
    /// Policy related to translation for an Instance
    struct TranslationPolicy: Codable
    {
        /// Is the translation API enabled on this instance?
        let enabled: Bool
    }
}
