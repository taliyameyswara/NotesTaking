//
//  NoteDetailViewModel.swift
//  NotesTaking
//
//  Created by Taliya Meyswara on 21/06/24.
//

import SwiftUI
import FirebaseFirestore

class NoteDetailViewModel: ObservableObject {
    @Published var note: Note
    private var dataSource: DataSource
    
    init(note: Note, dataSource: DataSource) {
        self.note = note
        self.dataSource = dataSource
    }

    func updateNote(completion: @escaping (Bool) -> Void) {
        dataSource.updateNote(note) { success in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    func saveAttributedContent(_ attributedContent: NSAttributedString, completion: @escaping (Bool) -> Void) {
        if let data = try? attributedContent.data(from: NSRange(location: 0, length: attributedContent.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd]) {
            note.attributedContent = data
        }
        updateNote(completion: completion)
    }


    func loadAttributedContent() -> NSAttributedString {
        guard let data = note.attributedContent else {
            return NSAttributedString(string: note.content)
        }
        return (try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.rtfd], documentAttributes: nil)) ?? NSAttributedString(string: note.content)
    }

}
