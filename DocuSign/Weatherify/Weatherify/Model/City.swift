//
//  City.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/10/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

public class City: Codable {
    public let id: Int
    public let name: String
    public let coord: Coord
    public let country: String
    public let population: Int
    public let timezone: Int
    public let sunrise: Int
    public let sunset: Int

    enum CodingKeys: String, CodingKey {
        case id, name, coord, country, population, timezone, sunrise, sunset
    }

    public init(id: Int = 0,
                name: String = "",
                coord: Coord = Coord(),
                country: String = "",
                population: Int = 0,
                timezone: Int = 0,
                sunrise: Int = 0,
                sunset: Int = 0
    ) {
        self.id = id
        self.name = name
        self.coord = coord
        self.country = country
        self.population = population
        self.timezone = timezone
        self.sunrise = sunrise
        self.sunset = sunset
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.coord = try container.decode(Coord.self, forKey: .coord)
        self.country = try container.decode(String.self, forKey: .country)
        self.population = try container.decode(Int.self, forKey: .population)
        self.timezone = try container.decode(Int.self, forKey: .timezone)
        self.sunrise = try container.decode(Int.self, forKey: .sunrise)
        self.sunset = try container.decode(Int.self, forKey: .sunset)
    }
}
