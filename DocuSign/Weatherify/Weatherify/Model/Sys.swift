//
//  Sys.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/10/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

public class Sys: Codable {
    private let pod: String

    enum CodingKeys: CodingKey {
        case pod
    }

    public init(pod: String = "") {
        self.pod = pod
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pod = try container.decode(String.self, forKey: .pod)
    }
}
