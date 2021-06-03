//
//  RosterStory.swift
//  RosterBusterDashboard
//
//  Created by Mayur Susare on 26/05/21.
//

import Foundation

// MARK: - RosterStoryElement
struct RosterStoryElement: Codable {
    let flightnr, date: String?
    let aircraftType: String?
    let tail, departure, destination, timeDepart: String?
    let timeArrive: String?
    let dutyID: DutyID?
    let dutyCode: DutyCode?
    let captain: String?
    let firstOfficer: String?
    let flightAttendant: String?

    enum CodingKeys: String, CodingKey {
        case flightnr = "Flightnr"
        case date = "Date"
        case aircraftType = "Aircraft Type"
        case tail = "Tail"
        case departure = "Departure"
        case destination = "Destination"
        case timeDepart = "Time_Depart"
        case timeArrive = "Time_Arrive"
        case dutyID = "DutyID"
        case dutyCode = "DutyCode"
        case captain = "Captain"
        case firstOfficer = "First Officer"
        case flightAttendant = "Flight Attendant"
    }
}

enum DutyCode: String, Codable {
    case flight = "FLIGHT"
    case layover = "LAYOVER"
    case off = "OFF"
    case positioning = "POSITIONING"
    case standby = "Standby"
}

enum DutyID: String, Codable {
    case dutyIDDO = "DO"
    case flt = "FLT"
    case ofd = "OFD"
    case pos = "POS"
    case sby = "SBY"
}


typealias RosterStory = [RosterStoryElement]

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

    func rosterStoryTask(with url: URL, completionHandler: @escaping (RosterStory?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}

