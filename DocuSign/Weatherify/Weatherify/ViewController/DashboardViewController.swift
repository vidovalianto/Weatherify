//
//  DashboardViewController.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/13/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import UIKit

public class DashboardViewController: UIViewController {
    public let dashboardVM = DashboardViewModel.shared
    private var cancellable : AnyCancellable?

    private let weatherStoryVC: WeatherStoryViewController = {
        let vc = WeatherStoryViewController()
        return vc
    }()

    private let halfView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private func initTableView() {
        tableView.register(WeatherListViewCell.self, forCellReuseIdentifier: WeatherListViewCell.cellId)
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine

        self.view.addSubview(tableView)

        NSLayoutConstraint.activate([
            self.tableView.heightAnchor.constraint(equalToConstant: self.view.bounds.height*2/3),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }

    private func initWeatherStoryView() {
        self.view.addSubview(halfView)

        NSLayoutConstraint.activate([
            halfView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            halfView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            halfView.bottomAnchor.constraint(equalTo: self.tableView.topAnchor),
            halfView.heightAnchor.constraint(equalToConstant: self.view.bounds.height/4)
        ])

        self.weatherStoryVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.weatherStoryVC.view.frame = self.halfView.bounds
        self.addChild(self.weatherStoryVC)
        self.halfView.addSubview(self.weatherStoryVC.view)
        self.weatherStoryVC.didMove(toParent: self)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        if dashboardVM.cities.isEmpty {
            self.addWeather()
        }

        self.initTableView()
        self.initWeatherStoryView()

        cancellable = dashboardVM.$respondModel.sink(receiveValue: { respond in
            self.weatherStoryVC.setDataSource(with: self.dashboardVM.cities,
                                              weathers: self.dashboardVM.respondModel.list)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        })

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(self.addWeather))
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                                    for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }

    override
    public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    deinit {
        cancellable?.cancel()
    }

    @objc
    private func addWeather() {
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension DashboardViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardVM.dailyModel.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherListViewCell.cellId) as! WeatherListViewCell
        cell.respondWeather = dashboardVM.dailyModel[indexPath.row]
        cell.configureTemp(temp: String(dashboardVM.dailyModel[indexPath.row].main.temp))
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WeatherListViewCell.cellSize
    }
}
