//
//  AddPinView.swift
//  Escale
//
//  Created by Thomas Gosse on 05/01/2021.
//

import SwiftUI
import MapKit
import Combine


struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var searchLandmarks: [SearchLandmark]
    @Binding var isPresented: Bool
    @Binding var query: String
    @Binding var mapState: MapState
    
    @ObservedObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Search place")) {
                        ZStack(alignment: .trailing) {
                            TextField("Places example", text: $viewModel.queryFragment)
                                .onChange(of: viewModel.queryFragment) { (_) in
                                    viewModel.region = mapState.region
                                }
                            if viewModel.status == .pending {
                                Image(systemName: "clock")
                                    .foregroundColor(.secondaryLabel)
                            }
                        }
                    }
                    if viewModel.status != .pending && viewModel.status != .idle {
                        Section(header: Text("Results")) {
                            List {
                                switch viewModel.status {
                                case .noResult: AnyView(Text("No results")).foregroundColor(.secondaryLabel)
                                case .error(let description): AnyView(Text("Error: \(description)")).foregroundColor(.red)
                                default: EmptyView()
                                }
                                ForEach(viewModel.results, id: \.self) { completionResult in
                                    Button(action: {
                                        self.startLocalSearch(completionResult: completionResult)
                                    }, label: {
                                        VStack(alignment: .leading) {
                                            Text(completionResult.title).foregroundColor(.label)
                                            Text(completionResult.subtitle).font(.subheadline).foregroundColor(.secondaryLabel)
                                        }
                                    })
                                }
                            }
                        }
                        // Added on 20/01/2021 to avoid weird animation on list refresh
                        .id(UUID())
                    }
                }
            }
            .navigationBarTitle("New place")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
            }.onChange(of: viewModel.status) { (val) in
                print(val)
            }
        }
    }
}

extension SearchView {
    func startLocalSearch(completionResult: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request.init(completion: completionResult)
        request.region = self.mapState.region
        let search = MKLocalSearch.init(request: request)
        search.start { (response, error) in
            guard let response = response else { return }
            searchLandmarks = response.mapItems.map({ (item) in
                return SearchLandmark(title: item.name, subtitle: item.placemark.title, coordinate: item.placemark.coordinate, countryCode: item.placemark.countryCode, pointOfInterestCategory: item.pointOfInterestCategory)
            })
            isPresented = false
            query = viewModel.queryFragment
        }
    }
}
