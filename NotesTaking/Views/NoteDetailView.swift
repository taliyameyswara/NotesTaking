//
//  NoteDetailView.swift
//  NotesTaking
//
//  Created by Taliya Meyswara on 21/06/24.
//
//
import SwiftUI
import RichTextKit

struct NoteDetailView: View {
    @ObservedObject var viewModel: NoteDetailViewModel
    @StateObject private var context = RichTextContext()
    @State private var attributedNoteText = NSAttributedString(string: "")
    @State private var isLoading: Bool = true
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        if isLoading {
            ProgressView("Loading...")
                .onAppear {
                    loadNoteContent()
                }
        } else {
            VStack {
                RichTextFormat.Toolbar(context: context)
                RichTextEditor(text: $attributedNoteText, context: context)
                    .padding()
                    .scrollContentBackground(.hidden)
                    .background(Color.black.opacity(0.3))
                
            }
            .focusedValue(\.richTextContext, context)
            .navigationTitle(viewModel.note.name)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        saveNote()
                    }) {
                        Label("Save", systemImage: "square.and.arrow.down")
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Save Note"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private func loadNoteContent() {
        DispatchQueue.main.async {
            self.attributedNoteText = viewModel.loadAttributedContent()
            self.isLoading = false
        }
    }

    private func saveNote() {
        viewModel.saveAttributedContent(attributedNoteText) { success in
            if success {
                alertMessage = "Note saved successfully!"
            } else {
                alertMessage = "Failed to save note. Please try again."
            }
            showAlert = true
        }
    }
}

