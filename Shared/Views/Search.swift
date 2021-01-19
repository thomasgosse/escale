//
//  AddPinView.swift
//  travelapp
//
//  Created by Thomas Gosse on 05/01/2021.
//

import SwiftUI
import MapKit
import Combine


struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var mapState: MapState

    @Binding var searchLandmarks: [SearchLandmark]
    @Binding var isPresented: Bool
    @Binding var query: String
    
    @ObservedObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Rechercher un lieu")) {
                        ZStack(alignment: .trailing) {
                            TextField("Ville, parc, restaurant...", text: $viewModel.queryFragment)
                                .onChange(of: viewModel.queryFragment) { (_) in
                                    viewModel.region = mapState.region
                                }
                            if viewModel.status == .pending {
                                Image(systemName: "clock")
                                    .foregroundColor(.secondaryLabel)
                            }
                        }
                    }
                    if viewModel.results.count > 0 {
                        Section(header: Text("Résultats")) {
                            List {
                                switch viewModel.status {
                                case .noResult: AnyView(Text("Pas de résultat")).foregroundColor(.secondaryLabel)
                                case .error(let description): AnyView(Text("Erreur: \(description)")).foregroundColor(.red)
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
                    }
                }
            }
            .navigationBarTitle("Nouveau lieu")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler", action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
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
