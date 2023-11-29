//
//  AddKeywordsToNoteView.swift
//  Jotter
//
//  Created by macbook on 24/11/2023.
//

import SwiftUI

struct AddKeywordsToNoteView: View {
    let note: Note
    @State private var searchTerm: String = ""
    @State private var selectedKeywords = Set<Keyword>()
    
    @FetchRequest(fetchRequest: Keyword.fetch(.all))
    var keywords: FetchedResults<Keyword>
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        VStack {
            HStack (spacing: 0) {
                Text("Add keywords to ")
                Text(note.title).bold()
            }
            
            HStack {
                TextField("search", text: $searchTerm)
                    .textFieldStyle(.roundedBorder)
                
                if searchTerm.count > 0 {
                    Button {
                        searchTerm = ""
                    } label: {
                        Text("clear")
                    }.foregroundColor(.pink)
                }
            }
            
            List (selection: $selectedKeywords) {
                ForEach (keywords) {key in
                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundColor(key.color)
                        Text(key.name)
                    }.tag(key)
                        .contextMenu {
                            Button("Delete Keyword") {
                                Keyword.delete(keyword:  key)
                            }
                        }
                }
            }.listStyle(.plain)
                .frame(minHeight: 150)
            if selectedKeywords.count > 0 {
                Button {
                    dismiss()
                    selectedKeywords.forEach { keyword in
                        note.keywords.insert(keyword)
                    }
                } label: {
                    Text("Add keywords to note")
                }
            } else if selectedKeywords.count == 0 {
                NewKeywordView(note: note, searchTerm: searchTerm)
            }

        }.padding()
            .onChange(of: searchTerm) { newValue in
                if newValue.count > 0 {
                    selectedKeywords = []
                    keywords.nsPredicate = NSPredicate(format: "%K CONTAINS[cd] %@",
                                                       KeywordProperties.name, searchTerm as CVarArg)
                } else {
                    keywords.nsPredicate = nil
                }
               
            }
       
    }
}

struct AddKeywordsToNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddKeywordsToNoteView(note: Note.example())
            .environment(\.managedObjectContext,
                          PersistenceController.preview.container.viewContext)
    }
}
