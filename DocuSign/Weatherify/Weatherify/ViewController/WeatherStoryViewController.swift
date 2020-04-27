//
//  WeatherScrollView.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/26/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation
import UIKit

public class WeatherStoryViewController: UIViewController {
    public static let cellId = "weatherCell"
    private var weathers: [RespondWeather] = [RespondWeather]()
    private var cities: [String] = [String]()
    private let dashboardVM = DashboardViewModel.shared

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(WeatherCollectionViewCell.self,
                                forCellWithReuseIdentifier: cellId)
        return collectionView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.initCollectionView()
    }

    private func initCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground

        self.view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.heightAnchor.constraint(equalTo: self.collectionView.widthAnchor, multiplier: 0.5)
        ])
    }

    public func setDataSource(with cities: [String],
                              weathers: [RespondWeather]) {
        self.cities = cities
        self.weathers = weathers
        self.collectionView.reloadData()
    }
}

extension WeatherStoryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cities.count == 1 ? self.view.bounds.width : self.view.bounds.width*4/5, height: self.view.bounds.height)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cities.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherStoryViewController.cellId, for: indexPath) as! WeatherCollectionViewCell
        cell.configure(city: self.cities[indexPath.row],
                       weather: self.weathers.first ?? RespondWeather())
        return cell
    }
}

extension WeatherStoryViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
        dashboardVM.locationQuery(city: dashboardVM.cities[visibleIndexPaths.first?[1] ?? visibleIndexPaths.last?[1] ?? 0 ])
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(!decelerate) {
            let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
            dashboardVM.locationQuery(city: dashboardVM.cities[visibleIndexPaths.first?[1] ?? visibleIndexPaths.last?[1] ?? 0 ])
        }
    }
}
