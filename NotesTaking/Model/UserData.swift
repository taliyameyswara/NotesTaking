//
//  UserModel.swift
//  NotesTaking
//
//  Created by Taliya Meyswara on 26/05/24.
//

import Foundation
import FirebaseFirestoreSwift // Diperlukan untuk Firestore

struct UserData: Decodable {
    var email: String
    var fullName: String
    var phoneNumber: String
}
