//
//  LocationSearch.swift
//  travelapp
//
//  Created by Thomas Gosse on 06/01/2021.
//

import SwiftUI
import MapKit
import Combine


enum LocationStatus: Equatable {
    case noResult
    case error(String)
    case result
    case pending
    case idle
}

class SearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var status: LocationStatus = .idle
    @Published var queryFragment: String = ""
    @Published var results: [MKLocalSearchCompletion] = []
    
    private var queryCancellable: AnyCancellable?
    private var searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()
    
    var region: MKCoordinateRegion = MKCoordinateRegion()
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        queryCancellable = $queryFragment
            .receive(on: DispatchQueue.main)
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main, options: nil)
            .sink{ receivedValue in
                self.status = .pending
                if !receivedValue.isEmpty {
                    self.searchCompleter.region = self.region
                    self.searchCompleter.queryFragment = receivedValue
                } else {
                    self.status = .idle
                    self.results = []
                }
            }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
        self.status = completer.results.isEmpty ? .noResult : .result
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.status = .error(error.localizedDescription)
    }
}
