//
//  DashboardViewModel.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/9/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import Foundation

public class DashboardViewModel {
    public static let shared = DashboardViewModel()
    private let networkManager = NetworkManager.shared
    private var cancellable: AnyCancellable?

    private init() {}

    @Published
    public var respondModel: RespondModel = RespondModel()

    public func locationQuery(city: String) {
        self.networkManager.loadWeather(city: city)
            .sink(receiveValue: { self.respondModel = $0 }).cancel()
    }
}
