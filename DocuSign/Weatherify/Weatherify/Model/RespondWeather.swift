//
//  Respond.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/10/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

public class RespondWeather: Codable {
    public let dtTxt: String
    public let rain: Rain?
    public let weathers: [Weather]
    public let main: Main
    public let wind: Wind
    public let cloud: Cloud
    public let dt: Double
    public let sys: Sys

    enum CodingKeys: String, CodingKey {
        case main, wind, sys, dt, rain,
        weathers = "weather",
        cloud = "clouds",
        dtTxt = "dt_txt"
    }

    public init(dtTxt: String = "",
                weathers: [Weather] = [Weather](),
                main: Main = Main(),
                visibility: String = "",
                wind: Wind = Wind(),
                rain: Rain = Rain(),
                cloud: Cloud = Cloud(),
                dt: Double = 0.0,
                sys: Sys = Sys()
    ) {
        self.dtTxt = dtTxt
        self.rain = rain
        self.weathers = weathers
        self.main = main
        self.wind = wind
        self.cloud = cloud
        self.dt = dt
        self.sys = sys
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dtTxt = try container.decode(String.self, forKey: .dtTxt)
        self.weathers = try container.decode([Weather].self, forKey: .weathers)
        self.main = try container.decode(Main.self, forKey: .main)
        self.rain = try container.decodeIfPresent(Rain.self, forKey: .rain)
        self.wind = try container.decode(Wind.self, forKey: .wind)
        self.cloud = try container.decode(Cloud.self, forKey: .cloud)
        self.dt = try container.decode(Double.self, forKey: .dt)
        self.sys = try container.decode(Sys.self, forKey: .sys)
    }
}

extension RespondWeather: Equatable {
    public static func == (lhs: RespondWeather, rhs: RespondWeather) -> Bool {
        return lhs.dtTxt.dayDateFormat() == rhs.dtTxt.dayDateFormat()
    }
}

extension RespondWeather: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.dtTxt.dayDateFormat().hashValue)
    }
}
