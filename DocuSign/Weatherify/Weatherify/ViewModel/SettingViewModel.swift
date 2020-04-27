//
//  SettingViewModel.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/27/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

final class SettingViewModel {
    static let shared = SettingViewModel()
    private let coreDataManager = CoreDataManager.shared

    private init() {}

    public func removeCity(for index: Int) {
        coreDataManager.removeCity(for: coreDataManager.cities[index])
    }

    public func getCity(for index: Int) -> String {
        return coreDataManager.cities[index]
    }

    public func fetchCities() -> [String] {
        return coreDataManager.cities
    }
    
}
