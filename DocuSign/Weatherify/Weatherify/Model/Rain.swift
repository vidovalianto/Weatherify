//
//  Rain.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/10/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

public class Rain: Codable {
    public let h: Double

    enum CodingKeys: String, CodingKey {
        case h = "3h"
    }

    public init(h: Double = 0.0) {
        self.h = h
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.h = try container.decode(Double.self, forKey: .h)
    }
}
