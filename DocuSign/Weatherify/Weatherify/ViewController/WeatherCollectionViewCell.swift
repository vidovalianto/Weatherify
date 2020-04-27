//
//  WeatherCollectionViewCell.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/26/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import Foundation
import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    private var cancellable: AnyCancellable?

    public var weather: RespondWeather = RespondWeather() {
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
        view.layer.cornerRadius = 10
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initCardView()
        self.initStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cancellable?.cancel()
    }

    private func initCardView() {
        self.contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            self.cardView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.cardView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.cardView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.cardView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)])
    }

    private func initStackView() {
        self.cardView.addSubview(self.cityLbl)

        NSLayoutConstraint.activate([
            cityLbl.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20),
            cityLbl.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20),
            cityLbl.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 20),
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

    public func configure(city: String, weather: RespondWeather) {
        self.cityLbl.text = city
        self.weather = weather
    }

    private func configureData() {

        self.cloudLbl.text = String(weather.cloud.all)
        self.windLbl.text = String(weather.wind.speed)
        self.highTempLbl.text = String(weather.main.tempMax)
        self.lowTempLbl.text = String(weather.main.tempMin)

        self.loadImage(id: self.weather.weathers.first?.icon ?? "").sink { [unowned self] image in
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
