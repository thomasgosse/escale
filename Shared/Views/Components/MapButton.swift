//
//  MapButton.swift
//  travelapp
//
//  Created by Thomas Gosse on 05/01/2021.
//

import SwiftUI


struct MapButton: View {
    private var action: () -> Void
    private var image: AnyView
    
    @State private var itemSize: CGFloat = 45
    
    init<V: View>(image: V, action: @escaping () -> Void) {
        self.image = AnyView(image)
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                Blur(style: .systemThinMaterial)
                    .frame(width: itemSize, height: itemSize)
                    .cornerRadius(5)
                image.frame(width: itemSize, height: itemSize)
            }
            .padding(.trailing, 20)
        }
    }
}
