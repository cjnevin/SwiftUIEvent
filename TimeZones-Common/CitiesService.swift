//
//  CitiesService.swift
//  TimeZones
//
//  Created by Chris Nevin on 16/9/21.
//

import Combine
import Foundation

class CitiesService: ObservableObject {
    func fetch() -> AnyPublisher<[City], Never> {
        Just(TimeZone.cities)
            .eraseToAnyPublisher()
    }

    func refresh() -> AnyPublisher<[City], Never> {
        fetch()
            .delay(for: 1.5, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

extension TimeZone {
    func asCity() -> City {
        City(
            id: identifier,
            current: self == .current,
            favourite: TimeZone.defaultTimeZoneIdentifiers.contains(identifier),
            gmtOffset: gmtOffset,
            name: cityName,
            time: currentTime
        )
    }
}

private extension TimeZone {
    static var defaultTimeZoneIdentifiers: [String] {
        [
            "Australia/Brisbane",
            "Europe/London",
            "America/New_York",
            "Europe/Paris",
            "Asia/Tokyo"
        ]
    }

    static var cities: [City] {
        knownTimeZoneIdentifiers
            .lazy
            .compactMap(TimeZone.init(identifier:))
            .map { $0.asCity() }
            .sorted()
    }

    var cityName: String {
        (identifier.components(separatedBy: "/").last ?? identifier)
            .replacingOccurrences(of: "_", with: " ")
    }

    var gmtOffset: String {
        let seconds = secondsFromGMT()
        let hours = seconds.hours
        let minutes = seconds.minutes
        return String(format: "GMT%@%02d:%02d", hours.prefix, abs(hours), minutes)
    }

    var currentTime: String {
        let formatter = DateFormatter()
        formatter.timeZone = self
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
}

private extension Int {
    static let oneHourInSeconds = oneMinuteInSeconds * 60
    static let oneMinuteInSeconds = 60

    var prefix: String {
        self >= 0 ? "+" : "-"
    }

    var hours: Int {
        self / .oneHourInSeconds
    }

    var minutes: Int {
        (self % .oneHourInSeconds) / .oneMinuteInSeconds
    }
}
