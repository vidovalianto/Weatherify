//
//  NetworkManager.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/9/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import UIKit

final class NetworkManager {
    public static let shared = NetworkManager()

    private let method: String = "GET"
    private let baseURL: URL = URL(string:"https://api.openweathermap.org/data/2.5/forecast?")!
    private let appKey = URLQueryItem(name:"appid", value:"135770bcd37e66027735e6a3a26973cc")
    private let iconUrl = URL(string:"https://openweathermap.org/img/w/")!;
    private var errorMessage = ""

    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()

    private init() {}

    public func loadWeather(city: String) -> AnyPublisher<RespondModel, Never> {
        let queryLocationToken = URLQueryItem(name:"q",
                                              value:city)
        var components = URLComponents(url: baseURL,
                                       resolvingAgainstBaseURL: false)
        components?.queryItems = [queryLocationToken, appKey]
        guard let url = components?.url else { return AnyPublisher(Just(RespondModel())) }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { return $0.data }
            .decode(type: RespondModel.self, decoder: JSONDecoder())
            .replaceError(with: RespondModel())
            .subscribe(on: backgroundQueue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    public func loadImage(id: String,
                          queue: OperationQueue) -> AnyPublisher<UIImage?, Never> {
        let url = iconUrl.appendingPathComponent(id + ".png")

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, _) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .subscribe(on: queue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
}
