//
//  Stops.swift
//  Arrival
//
//  Created by Michael Neas on 4/11/19.
//  Copyright © 2019 Michael Neas. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let stops = try? newJSONDecoder().decode(Stops.self, from: jsonData)

import Foundation

struct Stops: Codable {
    let data: [Datum]
    let jsonapi: Jsonapi
}

struct Datum: Codable {
    let attributes: Attributes
    let id: String
    let links: DatumLinks
    let relationships: Relationships
    let type: TypeEnum
}

struct Attributes: Codable {
    let address: String?
    let description: JSONNull?
    let latitude: Double
    let locationType: Int
    let longitude: Double
    let name: String
    let platformCode, platformName: JSONNull?
    let wheelchairBoarding: Int
    
    enum CodingKeys: String, CodingKey {
        case address, description, latitude
        case locationType = "location_type"
        case longitude, name
        case platformCode = "platform_code"
        case platformName = "platform_name"
        case wheelchairBoarding = "wheelchair_boarding"
    }
}

struct DatumLinks: Codable {
    let linksSelf: String
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

struct Relationships: Codable {
    let childStops: ChildStops
    let facilities: Facilities
    let parentStation: ParentStation
    
    enum CodingKeys: String, CodingKey {
        case childStops = "child_stops"
        case facilities
        case parentStation = "parent_station"
    }
}

struct ChildStops: Codable {
}

struct Facilities: Codable {
    let links: FacilitiesLinks
}

struct FacilitiesLinks: Codable {
    let related: String
}

struct ParentStation: Codable {
    let data: JSONNull?
}

enum TypeEnum: String, Codable {
    case stop = "stop"
}

struct Jsonapi: Codable {
    let version: String
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
