//
//  ViewController.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/9/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import CoreData
import MapKit
import UIKit

class SearchViewController: UIViewController {
    private let searchVM = SearchViewModel.shared
    private let locationManager = CLLocationManager()

    private var cancellable: AnyCancellable?
    private var searchController = UISearchController(searchResultsController: nil)
    private var isEditingSearch = false
    private var inputLocation = ""
    private var cities: [NSManagedObject] = []
    private var matchingItems: [MKMapItem] = []

    private let searchBarController: SearchBarController = {
        let searchBarController = SearchBarController()
        searchBarController.searchBar.placeholder = "Search Location"
        return searchBarController
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.setUserTrackingMode(.follow, animated: true)
        return mapView
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: WeatherListViewCell.cellId)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none

        let guide = self.view.safeAreaLayoutGuide
        self.view.addSubview(tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: guide.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }

    private func initMapView() {
        let guide = self.view.safeAreaLayoutGuide
        self.view.addSubview(mapView)

        mapView.center = self.view.center

        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: guide.topAnchor),
            self.mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }

    private func initSearchBar() {
        self.searchController = searchBarController

        self.searchController.searchBar.delegate = self

        self.navigationItem.searchController = self.searchController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        self.title = "Location"
        self.navigationController?.navigationBar.prefersLargeTitles = true;

        self.initSearchBar()
        self.initTableView()
        self.initMapView()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()

        cancellable = searchVM.$respondModel.sink(receiveValue: { _ in DispatchQueue.main.async {
            self.tableView.reloadData()
            }
        })

        cancellable = searchBarController.$matchingItems.sink(receiveValue: { items in
            self.matchingItems = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    deinit {
        cancellable?.cancel()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

        self.searchVM.respondModel = RespondModel()

        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        self.searchController.becomeFirstResponder()
    }

    private func save(name: String) {
        if CoreDataManager.shared.cities.contains(name) || name.trimmingCharacters(in: .whitespaces).isEmpty { return }

        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext

        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "FavoriteCity",
                                       in: managedContext)!

        let city = NSManagedObject(entity: entity,
                                   insertInto: managedContext)

        // 3
        city.setValue(name, forKeyPath: "name")

        // 4
        do {
            try managedContext.save()
            cities.append(city)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

        CoreDataManager.shared.fetchCoreData()
    }

    func parseAddress(selectedItem:MKPlacemark) -> String {
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            selectedItem.thoroughfare ?? "",
            comma,
            selectedItem.locality ?? "",
            secondSpace,
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }

    func getCity(from selectedItem:MKPlacemark) -> String {
        return selectedItem.locality ?? selectedItem.subAdministrativeArea ?? selectedItem.administrativeArea ?? selectedItem.title ?? self.searchBarController.searchBar.text!
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.backgroundView  = UIView()

        if searchVM.respondModel.list.isEmpty {
            if !isEditingSearch && self.searchController.searchBar.text?.isEmpty ?? true {
                self.tableView.backgroundView  = self.mapView
                self.tableView.isScrollEnabled = false
            } else {
                self.tableView.backgroundView  = self.dataPlaceHolderLbl
            }
        } else {
            self.inputLocation = self.searchController.searchBar.text ?? ""
            self.tableView.isScrollEnabled = true
        }

        return self.matchingItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = self.matchingItems[indexPath.row].placemark
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = parseAddress(selectedItem: result)
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = getCity(from: self.matchingItems[indexPath.row].placemark)
        self.save(name: city)
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isEditingSearch = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.isEditingSearch = false
    }
}

extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.first != nil {
            print("location:: (location)")
            print(locations)
        }

    }
}

