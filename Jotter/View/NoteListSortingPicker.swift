//
//  NoteListSortingPicker.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 30/01/2024.
//

import SwiftUI

struct NoteListSortingPicker: View {
    @Binding var selectedNoteSorting: NoteSorting
    var body: some View {
        Picker("Sort By", selection: $selectedNoteSorting.animation()) {
            ForEach(NoteSorting.allCases) {sorting in
                Text(sorting.title())
            }
        }
    }
}

#Preview {
    NoteListSortingPicker(selectedNoteSorting: .constant(.creationDateAsc))
}
