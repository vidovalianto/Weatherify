//
//  SearchBarController.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/10/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import Foundation
import UIKit

public class SearchBarController: UISearchController {
    private let dashboardVM = DashboardViewModel.shared
    private var cancellable: AnyCancellable?

    override
    public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.searchResultsUpdater = self
        self.definesPresentationContext = true
        self.searchBar.showsSearchResultsButton = true

    }

}

// we can use this too if there is no combine
extension SearchBarController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        if let locationQuery = searchBar.text {
            dashboardVM.locationQuery(city: locationQuery)
        }
    }
}
