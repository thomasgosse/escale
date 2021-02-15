//
//  EmptyList.swift
//  Escale
//
//  Created by Thomas Gosse on 15/02/2021.
//

import SwiftUI


struct EmptyList: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Int
    @Binding var selectedVisited: Int
    var hasPlaces: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if colorScheme == .dark {
                Color.systemBackground.edgesIgnoringSafeArea(.all)
            } else {
                Color.secondarySystemBackground.edgesIgnoringSafeArea([.all])
            }
            GeometryReader { geo in
                VStack(alignment: .center, spacing: 10) {
                    Image("EmptyList")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width)
                        .padding(.bottom)
                    Text(hasPlaces ? "No visited places title" : "Empty list title").font(.title2).fontWeight(.semibold).foregroundColor(.label)
                        .padding([.leading, .trailing], 30)
                        .multilineTextAlignment(.center)
                    Text(hasPlaces ? "No visited places subtitle" : "Empty list subtitle").fontWeight(.regular).foregroundColor(.secondaryLabel)
                        .padding([.leading, .trailing], 30)
                        .multilineTextAlignment(.center)
                    Button(action: {
                        if hasPlaces {
                            selectedVisited = 0
                        } else {
                            selectedTab = 0
                        }
                    }, label: {
                        Text(hasPlaces ? "No visited places button" : "Empty list button")
                        Image(systemName: hasPlaces ? "eyes" : "magnifyingglass")
                    })
                    .padding(.top)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: geo.size.height * 0.9)
            }
        }
    }
}


