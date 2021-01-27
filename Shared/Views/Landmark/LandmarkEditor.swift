//
//  LandmarkEditor.swift
//  travelapp
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

    var body: some View {
        NavigationView {
            List {
                Row(text: $title, name: "Nom")
                Row(text: $subtitle, name: "Complément")

                Section(header: Text("Lien")) {
                    ZStack(alignment: .leading) {
                        if urlString.isEmpty {
                                Text("Un lien qui vous rappelle/vous a fait découvrir ce lieu (Twitter, Instagram...)").foregroundColor(.tertiaryLabel)
                                    .padding([.leading, . trailing], 4)
                                    .padding([.top, .bottom], 8)
                        }
                        TextEditor(text: $urlString)
                    }
                    if let url = URL(string: urlString) {
                        if !UIApplication.shared.canOpenURL(url) {
                            HStack {
                                Image(systemName:"exclamationmark.triangle").foregroundColor(.yellow)
                                Text("Ce lien n'est pas valide")
                            }
                        }
                    }
                }
                .disableAutocorrection(true)
                
                MultilineRow(text: $personalNote, name: "Note personnelle",
                             placeholder: "Écrivez quelque chose que vous ne voulez pas oublier de ce lieu")
            }
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") { presentationMode.wrappedValue.dismiss() }
                }
            }
            .navigationBarItems(trailing: Button("Done", action: {
                landmark.title = title
                landmark.subtitle = subtitle
                landmark.personalNote = personalNote
                landmark.url = URL(string: self.urlString)
                presentationMode.wrappedValue.dismiss()
            }))
            .navigationTitle("Éditer")
        }
        .accentColor(.purple)
    }
    
    struct Row: View {
        @Binding var text: String
        var name: String
        
        var body: some View {
            Section(header: Text(name)) {
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
                if let url = URL(string: text) {
                    if !UIApplication.shared.canOpenURL(url) {
                        HStack {
                            Image(systemName:"exclamationmark.triangle").foregroundColor(.yellow)
                            Text("Ce lien n'est pas valide")
                        }
                    }
                }
            }
        }
    }
}


