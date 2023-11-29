//
//  NewKeywordView.swift
//  Jotter
//
//  Created by macbook on 24/11/2023.
//

import SwiftUI
import CoreData

struct NewKeywordView: View {
    @ObservedObject var note: Note
    let searchTerm: String
    
    let colorOptions = [Color(red: 0, green: 0, blue: 0),
                         Color(red: 1, green: 0, blue: 0),
                        Color(red: 1, green: 1, blue: 0),
                        Color(red: 0, green: 0, blue: 1),
                        Color(red: 0, green: 1, blue: 0)]
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedColor = Color(red: 0, green: 0, blue: 0)

    var body: some View {
        VStack {
            HStack {
                ForEach(colorOptions) { color in
                    Circle().fill(color)
                        .frame(width: selectedColor == color ? 20 : 15)
                        .onTapGesture {
                            selectedColor = color
                        }
                }
            }
            Button {
                let keyword = Keyword(name: searchTerm, context: viewContext)
                keyword.color = selectedColor
                note.keywords.insert(keyword)
                dismiss ()
            } label: {
                Text("Create as new Keyword")
            }.disabled(searchTerm.count == 0)
        }
    }
}

extension Color: Identifiable {
    public var id: String {
        var id = ""
        guard let components = self.cgColor?.components else {
            return id
        }
        for component in components {
            id.append(" \(component)")
        }
        return id
    }
}

struct NewKeywordView_Previews: PreviewProvider {
    static var previews: some View {
        NewKeywordView(note: Note.example(), searchTerm: "colorOptions")
            .environment(\.managedObjectContext,
                          PersistenceController.preview.container.viewContext)
    }
}
