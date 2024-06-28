//
//  FileItem.swift
//  NotesTaking
//
//  Created by Taliya Meyswara on 25/06/24.
//

import Foundation

import SwiftUI
import Firebase

struct FileItem: Identifiable, Codable {
    var id: String
    var userId: String
    var name: String
    var isFolder: Bool
    var parentID: String?
    var children: [FileItem]?
    var note: [Note]?
    
    var description: String {
        return isFolder ? (children?.isEmpty == false ? "📁 \(name)" : "📂 \(name)") : "📄 \(name)"
    }
    
}
