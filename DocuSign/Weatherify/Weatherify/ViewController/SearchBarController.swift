//
//  SearchBarController.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/10/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Combine
import Foundation
import MapKit
import UIKit

public class SearchBarController: UISearchController {
    private let searchVM = SearchViewModel.shared
    private var cancellable: AnyCancellable?
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    
    private var searchResults = [MKLocalSearchCompletion]()
    
    @Published
    public var matchingItems: [MKMapItem] = []
    
    override
    public func viewDidLoad() {
        super.viewDidLoad()
        self.searchResultsUpdater = self
        self.definesPresentationContext = true
        self.searchBar.showsSearchResultsButton = true
        self.searchCompleter.delegate = self
    }
    
    deinit {
        cancellable?.cancel()
    }
}

extension SearchBarController: MKLocalSearchCompleterDelegate {
}

extension SearchBarController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else { return }
            self.matchingItems = response.mapItems
        }
        searchCompleter.queryFragment = searchController.searchBar.text!
    }
}


