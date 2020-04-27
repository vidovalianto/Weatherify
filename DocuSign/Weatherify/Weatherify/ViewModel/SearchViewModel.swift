//
//  DashboardViewModel.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/9/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import CoreData
import Foundation

public class SearchViewModel {
    public static let shared = SearchViewModel()
    private let networkManager = NetworkManager.shared
    private var cancellable: AnyCancellable?

    private init() {}

    deinit {
        cancellable?.cancel()
    }

    @Published
    public var respondModel: RespondModel = RespondModel()

    public func locationQuery(city: String) {
        self.networkManager.loadWeather(city: city)
            .sink(receiveValue: { self.respondModel = $0 }).cancel()
    }
}
