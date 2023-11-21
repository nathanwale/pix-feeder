//
//  Date+.swift
//  Mastodon
//
//  Created by Nathan Wale on 20/9/2023.
//

import Foundation

extension Int
{
    func plural(_ word: String, pluralForm: String? = nil) -> String
    {
        if self == 1 {
            return word
        } else {
            return pluralForm ?? word + "s"
        }
    }
}

extension TimeInterval
{
    
    var minutes: Int {
        (Int(self) / 60)
    }
    
    var hours: Int {
        minutes / 60
    }
    
    var days: Int {
        hours / 24
    }
}

extension Date
{
    /// Readable format style
    /// eg.: 20 Sep 2023
    var readableFormat: FormatStyle {
        FormatStyle(
            date: .abbreviated,
            time: .omitted,
            locale: .current,
            calendar: .current,
            timeZone: .current,
            capitalizationContext: .listItem
        )
    }
    
    /// The difference between this date and the current time in seconds
    var secondsAgo: TimeInterval
    {
        distance(to: .now)
    }
    
    /// How many days ago is this date? Nil if failed
    var daysAgo: Int?
    {
        secondsAgo.days
    }
    
    /// How many hours ago is this date? Nil if failed
    var hoursAgo: Int?
    {
        secondsAgo.hours
    }
    
    /// Date formatted for readability.
    /// Uses relative times.
    /// eg.: 5 hours ago, 3 days ago, or 20 Sep 2023
    var relativeFormatted: String
    {
        if let hoursAgo = hoursAgo,
           hoursAgo < 24
        {
            // Within one day, report hours ago
            return "\(hoursAgo) \(hoursAgo.plural("hour")) ago"
        }
        else if
            let daysAgo = daysAgo,
            daysAgo < 7
        {
            // Within one week, report days ago
            return "\(daysAgo) \(daysAgo.plural("day")) ago"
        }
        else
        {
            // Older than a week, report full date
            return self.formatted(readableFormat)
        }
    }
}
