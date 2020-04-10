//
//  Coord.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/10/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

public class Coord: Codable {
    public let lat: Double
    public let lon: Double

    enum CodingKeys: CodingKey {
        case lat, lon
    }

    public init(lat: Double = 0.0,
                lon: Double = 0.0) {
        self.lat = lat
        self.lon = lon
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
    }
}
