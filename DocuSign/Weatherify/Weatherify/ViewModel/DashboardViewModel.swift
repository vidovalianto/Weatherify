//
//  DashboardViewModel.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/13/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import Foundation
import UIKit

public class DashboardViewModel {
    public static let shared = DashboardViewModel()
    private let coreDataManager = CoreDataManager.shared
    private let networkManager = NetworkManager.shared
    private var cancellable: AnyCancellable?
    
    public var cities = [String]() {
        didSet {
            self.locationQuery(city: cities.first ?? "")
        }
    }

    private init() {
        cancellable = coreDataManager.$cities.sink(receiveValue: { self.cities = $0
            })
        cities.forEach({ self.locationQuery(city: $0) })
    }

    deinit {
        cancellable?.cancel()
    }

    @Published
    public var respondModel: RespondModel = RespondModel() {
        didSet {
            self.calculateDailyModel()
        }
    }

    @Published
    public var dailyModel: [RespondWeather] = [RespondWeather]()

    public func locationQuery(city: String) {
        self.networkManager.loadWeather(city: city)
            .sink(receiveValue: { self.respondModel = $0 }).cancel()
    }

    public func calculateDailyModel() {
        var dict = [Date: RespondWeather]()

        respondModel.list.forEach { weather in
            if let _ = dict[weather.dtTxt.dateFormat()] {} else {
                dict[weather.dtTxt.dateFormat()] = weather
            }
        }

        self.dailyModel = dict.sorted(by: { $0.key < $1.key }).reduce([], { (res, arg1) -> [RespondWeather] in
            return res + [arg1.value]
        })
    }
}
