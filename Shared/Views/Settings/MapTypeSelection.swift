//
//  MapTypeSelection.swift
//  Escale
//
//  Created by Thomas Gosse on 12/02/2021.
//

import SwiftUI
import MapKit


struct MapTypeSelectionView: View {
    @Binding var draftMapType: MKMapType
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                MapTypeCardView(mapType: .standard, selected: $draftMapType)
                MapTypeCardView(mapType: .satellite, selected: $draftMapType)
                MapTypeCardView(mapType: .satelliteFlyover, selected: $draftMapType)
            }
            .padding([.top, .bottom], 8)
            .padding([.leading, .trailing], 2)
        }
    }
}
