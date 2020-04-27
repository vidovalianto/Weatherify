//
//  WeatherCard.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/13/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import UIKit

public class WeatherCardViewController: UIViewController {
    private var cancellable: AnyCancellable?

    private var respondWeather: RespondWeather? {
        didSet {
            configureData()
        }
    }

    public let backgroundImage: UIImageView = {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFit
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImage
    }()

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var cityLbl: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var highTempLbl: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var lowTempLbl: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var cloudLbl: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var windLbl: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var tempStackView: UIStackView = {
        let stackView = UIStackView(.vertical, subviews: [highTempLbl,lowTempLbl], alignment: .leading)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var conditionStackView: UIStackView = {
        let stackView = UIStackView(.horizontal,
                                    subviews: [windLbl, cloudLbl],
                                    alignment: .bottom)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(.horizontal,
                                    subviews: [tempStackView, conditionStackView],
                                    alignment: .bottom)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(.horizontal,
                                    subviews: [infoStackView],
                                    alignment: .center)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private func initCardView() {
        self.view.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            self.cardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.cardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.cardView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.cardView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
    }

    private func initStackView() {
        let guide = self.view.safeAreaLayoutGuide
        self.cardView.addSubview(self.cityLbl)

        NSLayoutConstraint.activate([
            cityLbl.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20),
            cityLbl.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20),
            cityLbl.topAnchor.constraint(equalTo: self.navigationController?.navigationBar.topAnchor ?? guide.topAnchor),
            cityLbl.heightAnchor.constraint(greaterThanOrEqualToConstant: self.cardView.bounds.height/3)
        ])

        self.cardView.addSubview(self.stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: self.cardView.bounds.height/2),
            stackView.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -20),
        ])

        self.cardView.addSubview(self.backgroundImage)

        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20),
            backgroundImage.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20),
            backgroundImage.topAnchor.constraint(equalTo: self.cityLbl.bottomAnchor, constant: 20),
            backgroundImage.bottomAnchor.constraint(equalTo: self.stackView.topAnchor, constant: -20)
        ])
    }

    public override func viewDidLoad() {
        self.initCardView()
        self.initStackView()
    }

    deinit {
        cancellable?.cancel()
    }

    public func configure(city: String, respondWeather: RespondWeather) {
        self.cityLbl.text = city
        self.respondWeather = respondWeather
    }

    public func configureData() {
        guard let respondWeather = self.respondWeather else { return }
        
        self.cloudLbl.text = String(respondWeather.cloud.all)
        self.windLbl.text = String(respondWeather.wind.speed)
        self.highTempLbl.text = String(respondWeather.main.tempMax)
        self.lowTempLbl.text = String(respondWeather.main.tempMin)

        self.loadImage(id: self.respondWeather?.weathers.first?.icon ?? "").sink { [unowned self] image in
            if image != nil {
                DispatchQueue.main.async {
                    self.showImage(image: image)
                }
            }
        }.cancel()
    }

    private func showImage(image: UIImage?) {
        backgroundImage.alpha = 1.0
        backgroundImage.image = image
    }

    private func loadImage(id: String) -> AnyPublisher<UIImage?, Never> {
        return ImageCachingManager.shared.loadImage(id: id).eraseToAnyPublisher()
    }
}
