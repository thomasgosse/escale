//
//  ListTab.swift
//  Escale
//
//  Created by Thomas Gosse on 06/01/2021.
//

import SwiftUI


struct ListTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var mapState: MapState
    
    @Binding var selectedTab: Int
    @State var selectedVisited = 0
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \LocalLandmark.title, ascending: true)])
    private var localLandmarks: FetchedResults<LocalLandmark>
    
    var filteredSections: [(key: String, value: [LocalLandmark])] {
        Dictionary(grouping: localLandmarks, by: {$0.countryCode ?? "N/A"})
            .mapValues { $0.filter { $0.visited == (selectedVisited == 1) } }
            .filter({ $0.value.count > 0 })
            .sorted(by: {$0.key<$1.key})
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if filteredSections.isEmpty {
                    EmptyList(selectedTab: $selectedTab, selectedVisited: $selectedVisited,
                              hasPlaces: localLandmarks.count > 0)
                } else {
                    List {
                        ForEach(filteredSections, id: \.key) { code, items in
                            Section(header: Text(getCountryFromCode(code))) {
                                ForEach(items) { item in
                                    if let title = item.title {
                                        NavigationLink(
                                            destination: LandmarkDetailView(landmark: item, selectedTab: $selectedTab)
                                        ) {
                                            Text(title)
                                        }
                                    }
                                }
                                .onDelete { deleteItem($0, items)}
                            }
                        }
                    }
                    // Added on 20/01/2021 to avoid weird animation on list refresh
                    .id(UUID())
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("My places")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker(selection: $selectedVisited, label: Text("To visit or not?")) {
                        Text("To visit").tag(0)
                        Text("Visited").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
    
    private func getCountryFromCode(_ code: String) -> String {
        return Locale.current.localizedString(forRegionCode: code) ?? "Other"
    }
    
    private func deleteItem(_ offsets: IndexSet, _ items: [LocalLandmark]) {
        withAnimation {
            if let index = offsets.first {
                mapState.deletedLandmark = items[index]
                viewContext.delete(items[index])
            }
        }
    }
}
