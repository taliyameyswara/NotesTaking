//
//  MainListView.swift
//  NotesTaking
//
//  Created by Taliya Meyswara on 28/06/24.
//

import SwiftUI

struct MainListView: View {
    @ObservedObject var dataSource: DataSource
    @Binding var showNewFolderAlert: Bool
    @Binding var showNewNoteAlert: Bool
    @Binding var newFolderName: String
    @Binding var newNoteTitle: String
    @Binding var newNoteContent: String
    @Binding var selectedFolderId: String?
    @Binding var selectedNoteId: String?
    
    var body: some View {
        List {
            Section(header: Text("Groups")) {
                FolderSection(dataSource: dataSource,
                              showNewNoteAlert: $showNewNoteAlert,
                              showNewFolderAlert: $showNewFolderAlert,
                              selectedFolderId: $selectedFolderId,
                              selectedNoteId: $selectedNoteId)
            }
            Section(header: Text("Notes")) {
                NotesSection(dataSource: dataSource, selectedNoteId: $selectedNoteId)
            }
        }
        .navigationTitle("NotesTaking")
        .toolbar {
            ToolbarItem {
                Button(action: {
                    showNewFolderAlert = true
                    selectedFolderId = nil // Root folder
                }) {
                    Image(systemName: "folder.badge.plus")
                }
                .help("Create Root Folder")
            }
            ToolbarItem {
                Button(action: {
                    selectedFolderId = nil
                    showNewNoteAlert = true
                }) {
                    Image(systemName: "square.and.pencil")
                }
                .help("Create Root Note")
            }
            ToolbarItem {
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.circle")
                }
            }
        }
        .onAppear {
            dataSource.fetchFoldersAndNotes()
        }
        .alert("New Folder", isPresented: $showNewFolderAlert) {
            VStack {
                TextField("Folder Name", text: $newFolderName)
                HStack {
                    Button("Create") {
                        dataSource.addFolder(name: newFolderName, parentId: selectedFolderId) { success in
                            if success {
                                print(selectedFolderId ?? "")
                                print("Folder created successfully")
                            } else {
                                print(selectedFolderId ?? "")
                                print("Failed to create folder")
                            }
                        }
                        newFolderName = ""
                        showNewFolderAlert = false
                    }
                    Button("Cancel", role: .cancel) {
                        newFolderName = ""
                        showNewFolderAlert = false
                    }
                }
            }
        }
        .alert("New Note", isPresented: $showNewNoteAlert) {
            VStack {
                TextField("Note Title", text: $newNoteTitle)
                HStack {
                    Button("Create") {
                        dataSource.addNote(title: newNoteTitle, folderId: selectedFolderId) { success in
                            if success {
                                print("Note created successfully")
                            } else {
                                print("Failed to create note")
                            }
                        }
                        newNoteTitle = ""
                        newNoteContent = ""
                        showNewNoteAlert = false
                    }
                    Button("Cancel", role: .cancel) {
                        newNoteTitle = ""
                        newNoteContent = ""
                        showNewNoteAlert = false
                    }
                }
            }
        }
    }
}


//#Preview {
//    MainListView()
//}
