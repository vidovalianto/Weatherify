//
//  RespondModel.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/10/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

public class RespondModel: Codable {
    public let cod: String
    public let message: Int
    public let cnt: Int
    public let list: [RespondWeather]
    public let city: City


    enum CodingKeys: CodingKey {
        case cod, message, cnt, list, city
    }

    public init(cod: String = "",
                message: Int = 0,
                cnt: Int = 0,
                list: [RespondWeather] = [RespondWeather](),
                city: City = City() ) {
        self.cod = cod
        self.message = message
        self.cnt = cnt
        self.list = list
        self.city = city
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cod = try container.decode(String.self, forKey: .cod)
        self.message = try container.decode(Int.self, forKey: .message)
        self.cnt = try container.decode(Int.self, forKey: .cnt)
        self.list = try container.decode([RespondWeather].self, forKey: .list)
        self.city = try container.decode(City.self, forKey: .city)
    }
}
