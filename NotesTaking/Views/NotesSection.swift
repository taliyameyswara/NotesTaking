//
//  NotesSection.swift
//  NotesTaking
//
//  Created by Taliya Meyswara on 28/06/24.
//

import SwiftUI

struct NotesSection: View {
    @ObservedObject var dataSource: DataSource
    @Binding var selectedNoteId: String?
    
    var body: some View {
        ForEach(dataSource.notes) { note in
            NavigationLink(destination: NoteDetailView(viewModel: NoteDetailViewModel(note: note, dataSource: dataSource))) {
                Text("📄 \(note.name)")
            }
            .onTapGesture {
                selectedNoteId = note.id
            }
        }
    }
}


//#Preview {
//    NotesSection()
//}
