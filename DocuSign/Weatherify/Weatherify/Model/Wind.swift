//
//  Wind.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/10/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

public class Wind: Codable {
    public let speed: Double
    public let deg: Double

    enum CodingKeys: CodingKey {
        case speed, deg
    }

    public init(speed: Double = 0.0,
                deg: Double = 0.0) {
        self.speed = speed
        self.deg = deg
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.speed = try container.decode(Double.self, forKey: .speed)
        self.deg = try container.decode(Double.self, forKey: .deg)
    }
}
