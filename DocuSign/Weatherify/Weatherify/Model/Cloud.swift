//
//  Cloud.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/10/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

public class Cloud: Codable {
    public let all: Int

    enum CodingKeys: CodingKey {
        case all
    }

    public init(all: Int = 0) {
        self.all = all
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.all = try container.decode(Int.self, forKey: .all)
    }
}
