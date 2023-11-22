//
//  JSONDecoder_DateDecodingStrategy.swift
//  PixFeeder
//
//  Created by Nathan Wale on 8/9/2023.
//

import Foundation


extension JSONDecoder.DateDecodingStrategy
{
    ///
    /// Date decoding strategy to cover the different formats found
    /// in the Mastodon API
    ///
    static var mastodon: JSONDecoder.DateDecodingStrategy
    {
        JSONDecoder.DateDecodingStrategy.custom
        {
            decoder in
            
            let singleValue = try decoder.singleValueContainer()
            let dateString = try singleValue.decode(String.self)
            let formatter = ISO8601DateFormatter()
            
            if dateString.count == 10 {
                formatter.formatOptions = [
                    .withFullDate,
                    .withDashSeparatorInDate,
                ]
            } else {
                formatter.formatOptions = [
                    .withFullDate,
                    .withFullTime,
                    .withDashSeparatorInDate,
                    .withFractionalSeconds,
                ]
            }
            
            guard let date = formatter.date(from: dateString)
            else {
                throw DecodingError.dataCorruptedError(
                    in: singleValue,
                    debugDescription: "Failed to decode string \"\(dateString)\" as ISO 8601 date"
                )
            }
            
            return date
        }
    }
}
