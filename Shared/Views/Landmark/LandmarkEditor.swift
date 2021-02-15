//
//  LandmarkEditor.swift
//  Escale
//
//  Created by Thomas Gosse on 22/01/2021.
//

import SwiftUI
import Combine


struct LandmarkEditorView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var landmark: LocalLandmark
    
    @State private var title: String
    @State private var subtitle: String
    @State private var personalNote: String
    @State private var urlString: String
    
    init(_ landmark: LocalLandmark) {
        self.landmark = landmark
        _title = .init(initialValue: landmark.title)
        _subtitle = .init(initialValue: landmark.subtitle)
        _personalNote = .init(initialValue: landmark.personalNote)
        _urlString = .init(initialValue: landmark.url?.absoluteString ?? "")
    }
    
    func onCommit() {}
    
    var body: some View {
        NavigationView {
            List {
                Row(text: $title, name: "Name")
                Row(text: $subtitle, name: "Details")
                
                Section(header: Text("Link")) {
                    TextView("Link placeholder",
                             text: $urlString,
                             onCommit: onCommit)
                    if let url = URL(string: urlString) {
                        if !UIApplication.shared.canOpenURL(url) {
                            HStack {
                                Image(systemName:"exclamationmark.triangle").foregroundColor(.yellow)
                                Text("Invalid link")
                            }
                        }
                    }
                }
                .disableAutocorrection(true)
                
                Section(header: Text("Personal note")) {
                    TextView("Personal note placeholder",
                             text: $personalNote,
                             onCommit: onCommit)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
            }
            .navigationBarItems(trailing: Button("Done", action: {
                landmark.title = title
                landmark.subtitle = subtitle
                landmark.personalNote = personalNote
                landmark.url = URL(string: self.urlString)
                presentationMode.wrappedValue.dismiss()
            }))
            .navigationTitle("Edit place")
        }
        .accentColor(.purple)
    }
    
    struct Row: View {
        @Binding var text: String
        var name: String
        
        var body: some View {
            Section(header: Text(NSLocalizedString(name, comment: "Field section header"))) {
                TextField(name, text: $text)
            }
        }
    }
    
    struct MultilineRow: View {
        @Binding var text: String
        var name: String
        var placeholder: String
        
        var body: some View {
            Section(header: Text(name)) {
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(placeholder).foregroundColor(.tertiaryLabel)
                            .padding([.leading, . trailing], 4)
                            .padding([.top, .bottom], 8)
                    }
                    TextEditor(text: $text)
                }
            }
        }
    }
}
