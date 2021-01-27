//
//  CardStyle.swift
//  travelapp
//
//  Created by Thomas Gosse on 22/01/2021.
//

import SwiftUI


struct CardStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var paddingX: CGFloat
    var paddingY: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .trailing], paddingX)
            .padding([.top, .bottom], paddingY)
            .background(colorScheme == .dark ? Color.tertiarySystemFill : Color.systemBackground)
            .cornerRadius(12)
            .padding([.leading, .trailing, .bottom])
    }
}

extension View {
    func cardStyle(paddingX: CGFloat, paddingY: CGFloat) -> some View {
        ModifiedContent(content: self, modifier: CardStyle(paddingX: paddingX, paddingY: paddingY))
    }
}
