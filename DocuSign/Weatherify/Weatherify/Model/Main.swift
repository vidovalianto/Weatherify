//
//  Main.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/10/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

public class Main: Codable {
    public let temp: Double
    public let feelsLike: Double
    public let tempMin: Double
    public let tempMax: Double
    public let pressure: Int
    public let seaLevel: Int
    public let grndLevel: Int
    public let humidity: Int
    public let tempKf: Double


    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity,
        feelsLike = "feels_like",
        tempMin = "temp_min",
        tempMax = "temp_max",
        seaLevel = "sea_level",
        grndLevel = "grnd_level",
        tempKf = "temp_kf"
    }

    public init(temp: Double = 0.0,
                feelsLike: Double = 0.0,
                pressure: Int = 0,
                humidity: Int = 0,
                tempMin: Double = 0.0,
                tempMax: Double = 0.0,
                seaLevel: Int = 0,
                grndLevel: Int = 0,
                tempKf: Double = 0.0) {
        self.temp = temp
        self.feelsLike = feelsLike
        self.pressure = pressure
        self.humidity = humidity
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.seaLevel = seaLevel
        self.grndLevel = grndLevel
        self.tempKf = tempKf
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decode(Double.self, forKey: .temp)
        self.feelsLike = try container.decode(Double.self, forKey: .feelsLike)
        self.pressure = try container.decode(Int.self, forKey: .pressure)
        self.humidity = try container.decode(Int.self, forKey: .humidity)
        self.tempMin = try container.decode(Double.self, forKey: .tempMin)
        self.tempMax = try container.decode(Double.self, forKey: .tempMax)
        self.seaLevel = try container.decode(Int.self, forKey: .seaLevel)
        self.grndLevel = try container.decode(Int.self, forKey: .grndLevel)
        self.tempKf = try container.decode(Double.self, forKey: .tempKf)
    }
}
