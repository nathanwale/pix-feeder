//
//  ImageRequest.swift
//  RecipeApp
//
//  Created by Nathan Wale on 20/4/2023.
//

import UIKit

///
/// Fetch an Image from self.url
///
struct ImageRequest
{
    ///
    /// Error cases for fetching imag
    ///
    enum RequestError: Error
    {
        case couldNotInitialiseFromData
        case imageDataMissing
    }
    
    /// url to fetch
    let url: URL

    /// send request, returns UIImage if successful
    func send() async throws -> UIImage
    {
        // create url request
        let request = URLRequest(url: url)
        
        // fetch data and response
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard
            // ensure response is an HTTP response
            let httpResponse = response as? HTTPURLResponse,
            // ensure status code is OK
            httpResponse.statusCode == 200
        else {
            // ...else throw error
            throw RequestError.imageDataMissing
        }
        
        // Ensure we can decode data as UIImage
        guard let image = UIImage(data: data) else {
            throw RequestError.couldNotInitialiseFromData
        }
        
        // image is fine to return
        return image
    }
}
