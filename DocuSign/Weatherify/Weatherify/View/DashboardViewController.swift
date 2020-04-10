//
//  ViewController.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/9/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import UIKit

class DashboardViewController: UIViewController {
    private let dashboardVM = DashboardViewModel.shared
    private var cancellable: AnyCancellable?
    private var searchController = UISearchController(searchResultsController: nil)
    private var isEditingSearch = false

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var logoView: UIImageView = {
        let frame = CGRect(x: 0,
                           y: 0,
                           width: self.view.bounds.size.width,
                           height: self.view.bounds.size.height)

        let imageView = UIImageView(frame: frame)
        let size = CGSize(width: 200.0, height: 200.0)
        imageView.image = UIImage(named: "openweather")?.resizeImage(targetSize: size)
        imageView.contentMode = .center

        return imageView
    }()

    private lazy var dataPlaceHolderLbl: UILabel = {
        let frame = CGRect(x: 0,
                           y: 0,
                           width: self.tableView.bounds.size.width,
                           height: self.tableView.bounds.size.height)

        let label: UILabel  = UILabel(frame: frame)
        label.text          = "Location Result Unavailable"
        label.textColor     = .tertiarySystemGroupedBackground
        label.textAlignment = .center
        label.center = self.view.center
        return label
    }()

    private func initTableView() {
        let guide = self.view.safeAreaLayoutGuide
        self.view.addSubview(tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: guide.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.title = "Weatherify"
        self.navigationController?.navigationBar.prefersLargeTitles = true;

        initTableView()
        tableView.register(WeatherListViewCell.self, forCellReuseIdentifier: WeatherListViewCell.cellId)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none

        self.searchController = SearchBarController()
        self.searchController.searchBar.delegate = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = true

        cancellable = dashboardVM.$respondModel.sink(receiveValue: { _ in DispatchQueue.main.async { self.tableView.reloadData() } })
    }
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.backgroundView  = UIView()

        if dashboardVM.respondModel.list.isEmpty {
            if !isEditingSearch && self.searchController.searchBar.text?.isEmpty ?? true {
                self.tableView.backgroundView  = self.logoView
            } else {
                self.tableView.backgroundView  = self.dataPlaceHolderLbl
            }
        }
        return dashboardVM.respondModel.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherListViewCell.cellId) as! WeatherListViewCell
        cell.respondWeather = dashboardVM.respondModel.list[indexPath.row]
        cell.configureTemp(temp: String(dashboardVM.respondModel.list[indexPath.row].main.temp))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WeatherListViewCell.cellSize
    }
}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension DashboardViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isEditingSearch = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.isEditingSearch = false
    }
}


