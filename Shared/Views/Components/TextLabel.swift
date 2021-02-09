//
//  TextLabel.swift
//  Escale
//
//  Created by Thomas Gosse on 08/02/2021.
//

import SwiftUI


struct TextLabel: View {
    private var text: String
    private var label: String
    
    init(_ text: String, _ label: String) {
        self.text = text
        self.label = label
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label).font(.subheadline).foregroundColor(.secondaryLabel)
            Text(text)
        }
    }
}
