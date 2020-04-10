//
//  Weather.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/9/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

public class Weather: Codable {
    public let id: Int
    public let main: String
    public let description: String
    public let icon: String

    enum CodingKeys: CodingKey {
        case id, main, description, icon
    }

    public init(id: Int = 0,
                main: String = "",
                description: String = "",
                icon: String = "") {
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.main = try container.decode(String.self, forKey: .main)
        self.description = try container.decode(String.self, forKey: .description)
        self.icon = try container.decode(String.self, forKey: .icon)
    }
}
