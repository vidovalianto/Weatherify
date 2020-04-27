//
//  WeatherListViewCell.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/10/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import UIKit

final class WeatherListViewCell: UITableViewCell {
    public static let cellId = "weatherCell"
    public static let cellSize: CGFloat = 130
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?

    public var respondWeather: RespondWeather? {
        didSet {
            dayLbl.text = self.respondWeather?.dtTxt.dayDateFormat()
            self.loadImage(id: self.respondWeather?.weathers.first?.icon ?? "").sink { [unowned self] image in
                DispatchQueue.main.async {
                    self.showImage(image: image)
                }
            }.cancel()
            descLbl.text = self.respondWeather?.weathers.first?.description
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)

        self.initConstraint()
    }

    private let cardView: UIView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let dayLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = appFont(section: .footer)
        lbl.textAlignment = .left
        return lbl
    }()

    private let tempLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = appFont(section: .barTitle)
        lbl.font = UIFont.monospacedDigitSystemFont(ofSize: 16,
                                                    weight: .medium)
        lbl.textAlignment = .left
        return lbl
    }()

    public let backgroundImage: UIImageView = {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFit
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImage
    }()

    private let descLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = appFont(section: .desc)
        lbl.textAlignment = .left
        return lbl
    }()

    fileprivate lazy var weatherStackView: UIStackView = { [unowned self] in
        let stackView = UIStackView(arrangedSubviews: [self.dayLbl, self.tempLbl])
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    fileprivate lazy var stackView: UIStackView = { [unowned self] in
        let stackView = UIStackView(arrangedSubviews: [self.weatherStackView, self.backgroundImage,self.descLbl])
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    deinit {
        animator?.stopAnimation(true)
        animator?.finishAnimation(at: .current)
        cancellable?.cancel()
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImage.image = nil
        backgroundImage.alpha = 0.0
        animator?.stopAnimation(true)
        cancellable?.cancel()
    }

    public func configureTemp(temp: String) {
        self.tempLbl.text = temp
    }

    private func showImage(image: UIImage?) {
        backgroundImage.alpha = 0.0
        animator?.stopAnimation(false)
        backgroundImage.image = image
        self.backgroundImage.alpha = 1.0
    }

    private func loadImage(id: String) -> AnyPublisher<UIImage?, Never> {
        return ImageCachingManager.shared.loadImage(id: id).eraseToAnyPublisher()
    }

    private func initConstraint() {
        self.addSubview(cardView)

        self.cardView.addSubview(stackView)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                               constant: 20),
            cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                constant: -20),
            cardView.topAnchor.constraint(equalTo: self.topAnchor,
            constant: 20),
            cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
            constant: -20),

            stackView.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor,
            constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor,
            constant: -20),
            stackView.topAnchor.constraint(equalTo: self.cardView.topAnchor,
            constant: 20),
            stackView.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor,
            constant: -20),
        ])
        
    }
}
