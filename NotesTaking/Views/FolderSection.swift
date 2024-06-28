//
//  FolderSection.swift
//  NotesTaking
//
//  Created by Taliya Meyswara on 28/06/24.
//

import SwiftUI

struct FolderSection: View {
    @ObservedObject var dataSource: DataSource
    @Binding var showNewNoteAlert: Bool
    @Binding var showNewFolderAlert: Bool
    @Binding var selectedFolderId: String?
    @Binding var selectedNoteId: String?
    
    var body: some View {
        ForEach(dataSource.folders) { folder in
            DisclosureGroup {
                if let folderNotes = dataSource.notesByFolder[folder.id] {
                    ForEach(folderNotes) { note in
                        NavigationLink(destination: NoteDetailView(viewModel: NoteDetailViewModel(note: note, dataSource: dataSource))
                            .onAppear {
                                selectedNoteId = note.id
                            }
                        ) {
                            Text("📄 \(note.name)")
                                .font(.subheadline)
                        }
                    }
                }
            } label: {
                NavigationLink(destination: FolderDetailView(dataSource: dataSource, selectedFolderId: folder.id)
                    .onAppear {
                        selectedFolderId = folder.id
                        selectedNoteId = nil
                    }
                ) {
                    Text(folder.description)
                        .font(.headline)
                }
            }
            .contextMenu {
                Button(action: {
                    showNewNoteAlert = true
                    selectedFolderId = folder.id
                }) {
                    HStack {
                        Image(systemName: "square.and.pencil")
                        Text("New Note")
                    }
                }
            }
        }
    }
}
//#Preview {
//    FolderSection()
//}
