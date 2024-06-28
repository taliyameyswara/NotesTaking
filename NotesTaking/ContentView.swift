//
//  ContentView.swift
//  NotesTaking
//
//  Created by Taliya Meyswara on 26/05/24.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @StateObject private var dataSource = DataSource()
    @State private var showNewFolderAlert = false
    @State private var showNewNoteAlert = false
    @State private var newFolderName = ""
    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""
    @State private var selectedFolderId: String?
    @State private var selectedNoteId: String?
    
    var body: some View {
        NavigationSplitView {
            MainListView(dataSource: dataSource,
                         showNewFolderAlert: $showNewFolderAlert,
                         showNewNoteAlert: $showNewNoteAlert,
                         newFolderName: $newFolderName,
                         newNoteTitle: $newNoteTitle,
                         newNoteContent: $newNoteContent,
                         selectedFolderId: $selectedFolderId,
                         selectedNoteId: $selectedNoteId)
        } detail: {
//            if let noteId = selectedNoteId, let note = dataSource.notes.first(where: { $0.id == noteId }) {
//                NoteDetailView(viewModel: NoteDetailViewModel(note: note, dataSource: dataSource))
//            } else {
                Text("Select a file or folder to view details")
//            }
        }
    }
}

//struct MainListView: View {
//    @ObservedObject var dataSource: DataSource
//    @Binding var showNewFolderAlert: Bool
//    @Binding var showNewNoteAlert: Bool
//    @Binding var newFolderName: String
//    @Binding var newNoteTitle: String
//    @Binding var newNoteContent: String
//    @Binding var selectedFolderId: String?
//    @Binding var selectedNoteId: String?
//
//    var body: some View {
//        List {
//            Section(header: Text("Groups")) {
//                FolderSection(dataSource: dataSource,
//                              showNewNoteAlert: $showNewNoteAlert,
//                              showNewFolderAlert: $showNewFolderAlert,
//                              selectedFolderId: $selectedFolderId,
//                              selectedNoteId: $selectedNoteId)
//            }
//            Section(header: Text("Notes")) {
//                NotesSection(dataSource: dataSource, selectedNoteId: $selectedNoteId)
//            }
//        }
//        .navigationTitle("NotesTaking")
//        .toolbar {
//            ToolbarItem {
//                Button(action: {
//                    showNewFolderAlert = true
//                    selectedFolderId = nil // Root folder
//                }) {
//                    Image(systemName: "folder.badge.plus")
//                }
//                .help("Create Root Folder")
//            }
//            ToolbarItem {
//                Button(action: {
//                    selectedFolderId = nil
//                    showNewNoteAlert = true
//                }) {
//                    Image(systemName: "square.and.pencil")
//                }
//                .help("Create Root Note")
//            }
//            ToolbarItem {
//                NavigationLink(destination: ProfileView()) {
//                    Image(systemName: "person.circle")
//                }
//            }
//        }
//        .onAppear {
//            dataSource.fetchFoldersAndNotes()
//        }
//        .alert("New Folder", isPresented: $showNewFolderAlert) {
//            VStack {
//                TextField("Folder Name", text: $newFolderName)
//                HStack {
//                    Button("Create") {
//                        dataSource.addFolder(name: newFolderName, parentId: selectedFolderId) { success in
//                            if success {
//                                print(selectedFolderId ?? "")
//                                print("Folder created successfully")
//                            } else {
//                                print(selectedFolderId ?? "")
//                                print("Failed to create folder")
//                            }
//                        }
//                        newFolderName = ""
//                        showNewFolderAlert = false
//                    }
//                    Button("Cancel", role: .cancel) {
//                        newFolderName = ""
//                        showNewFolderAlert = false
//                    }
//                }
//            }
//        }
//        .alert("New Note", isPresented: $showNewNoteAlert) {
//            VStack {
//                TextField("Note Title", text: $newNoteTitle)
//                HStack {
//                    Button("Create") {
//                        dataSource.addNote(title: newNoteTitle, folderId: selectedFolderId) { success in
//                            if success {
//                                print("Note created successfully")
//                            } else {
//                                print("Failed to create note")
//                            }
//                        }
//                        newNoteTitle = ""
//                        newNoteContent = ""
//                        showNewNoteAlert = false
//                    }
//                    Button("Cancel", role: .cancel) {
//                        newNoteTitle = ""
//                        newNoteContent = ""
//                        showNewNoteAlert = false
//                    }
//                }
//            }
//        }
//    }
//}

//struct FolderSection: View {
//    @ObservedObject var dataSource: DataSource
//    @Binding var showNewNoteAlert: Bool
//    @Binding var showNewFolderAlert: Bool
//    @Binding var selectedFolderId: String?
//    @Binding var selectedNoteId: String?
//
//    var body: some View {
//        ForEach(dataSource.folders) { folder in
//            DisclosureGroup {
//                if let folderNotes = dataSource.notesByFolder[folder.id] {
//                    ForEach(folderNotes) { note in
//                        NavigationLink(destination: NoteDetailView(viewModel: NoteDetailViewModel(note: note, dataSource: dataSource))
//                            .onAppear {
//                                selectedNoteId = note.id
//                            }
//                        ) {
//                            Text("📄 \(note.name)")
//                                .font(.subheadline)
//                        }
//                    }
//                }
//            } label: {
//                NavigationLink(destination: FolderDetailView(dataSource: dataSource, selectedFolderId: folder.id)
//                    .onAppear {
//                        selectedFolderId = folder.id
//                        selectedNoteId = nil
//                    }
//                ) {
//                    Text(folder.description)
//                        .font(.headline)
//                }
//            }
//            .contextMenu {
//                Button(action: {
//                    showNewNoteAlert = true
//                    selectedFolderId = folder.id
//                }) {
//                    HStack {
//                        Image(systemName: "square.and.pencil")
//                        Text("New Note")
//                    }
//                }
//            }
//        }
//    }
//}

//struct NotesSection: View {
//    @ObservedObject var dataSource: DataSource
//    @Binding var selectedNoteId: String?
//
//    var body: some View {
//        ForEach(dataSource.notes) { note in
//            NavigationLink(destination: NoteDetailView(viewModel: NoteDetailViewModel(note: note, dataSource: dataSource))
//                .onAppear {
//                    selectedNoteId = note.id
//                }
//            ) {
//                Text("📄 \(note.name)")
//            }
//        }
//    }
//}

//struct FolderDetailView: View {
//    @ObservedObject var dataSource: DataSource
//    let selectedFolderId: String
//
//    var body: some View {
//        VStack {
//            if let folder = dataSource.folders.first(where: { $0.id == selectedFolderId }),
//               let folderNotes = dataSource.notesByFolder[folder.id] {
//                List(folderNotes) { note in
//                    NavigationLink(destination: NoteDetailView(viewModel: NoteDetailViewModel(note: note, dataSource: dataSource))) {
//                        Text("📄 \(note.name)")
//                    }
//                }
//                .transition(.slide)
//            } else {
//                Text("Select a folder to view its notes")
//                    .foregroundColor(.gray)
//            }
//        }
//        .navigationTitle(dataSource.folders.first(where: { $0.id == selectedFolderId })?.name ?? "Folder Details")
//    }
//}
