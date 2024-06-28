//
//  FolderDetailView.swift
//  NotesTaking
//
//  Created by Taliya Meyswara on 28/06/24.
//

import SwiftUI

struct FolderDetailView: View {
    @ObservedObject var dataSource: DataSource
    let selectedFolderId: String
    
    var body: some View {
        VStack {
            if let folder = dataSource.folders.first(where: { $0.id == selectedFolderId }),
               let folderNotes = dataSource.notesByFolder[folder.id] {
                List(folderNotes) { note in
                    NavigationLink(destination: NoteDetailView(viewModel: NoteDetailViewModel(note: note, dataSource: dataSource))) {
                        Text("📄 \(note.name)")
                    }
                }
                .transition(.slide)
            } else {
                Text("Select a folder to view its notes")
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle(dataSource.folders.first(where: { $0.id == selectedFolderId })?.name ?? "Folder Details")
    }
}

//#Preview {
//    FolderDetailView()
//}
