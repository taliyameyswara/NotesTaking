//
//  Note.swift
//  NotesTaking
//
//  Created by Taliya Meyswara on 09/06/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Note: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var userId: String
    var parentID: String
    var content: String
    var createdAt: Date
    var updatedAt: Date
    var attributedContent: Data?
}

