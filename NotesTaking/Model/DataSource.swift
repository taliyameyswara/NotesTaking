import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class DataSource: ObservableObject {
    @Published var folders: [FileItem] = []
    @Published var notes: [Note] = []
    @Published var notesByFolder: [String: [Note]] = [:]
    @Published var selectedFolderId: String?
    @Published var selectedNoteId: String?
    
    private let firestore = Firestore.firestore()
    private let auth = Auth.auth()
    
    func createUser(email: String, fullName: String, phoneNumber: String, completion: @escaping (Bool) -> Void) {
        guard let user = auth.currentUser else { return }
        
        firestore.collection("users").document(user.uid).setData([
            "id": user.uid,
            "email": email,
            "fullName": fullName,
            "phoneNumber": phoneNumber
        ]) { error in
            completion(error == nil)
        }
    }
    
    func fetchUserData(userId: String, completion: @escaping (Result<UserData, Error>) -> Void) {
        firestore.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let document = document, document.exists, let _ = document.data() {
                do {
                    let userData = try document.data(as: UserData.self)
                    completion(.success(userData))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "No user data found", code: 404, userInfo: nil)))
            }
        }
    }
    
    func fetchFoldersAndNotes() {
        guard let userId = auth.currentUser?.uid else { return }

        // Fetch folders in real-time
        firestore.collection("folders").whereField("userId", isEqualTo: userId).addSnapshotListener { folderSnapshot, error in
            if let error = error {
                print("Error fetching folders: \(error)")
                return
            }

            var folders: [FileItem] = []

            // Process each folder
            folderSnapshot?.documents.forEach { document in
                guard let folder = try? document.data(as: FileItem.self) else { return }
                folders.append(folder)

                // Fetch notes inside each folder in real-time
                self.fetchNotesInFolder(folderId: folder.id, userId: userId) { folderNotes in
                    self.notesByFolder[folder.id] = folderNotes
                    print("Fetched notes in folder \(folder.id) successfully.")
                }
            }

            // Assign folders after processing
            self.folders = folders
            print("Fetched folders successfully.")
        }

        // Fetch top-level notes (notes not in any folder) in real-time
        firestore.collection("notes").whereField("userId", isEqualTo: userId).whereField("parentID", isEqualTo: "").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching top-level notes: \(error)")
                return
            }

            self.notes = querySnapshot?.documents.compactMap { document -> Note? in
                try? document.data(as: Note.self)
            } ?? []

            print("Fetched top-level notes successfully.")
        }
    }

    // Helper function to fetch notes in a folder in real-time
    private func fetchNotesInFolder(folderId: String, userId: String, completion: @escaping ([Note]) -> Void) {
        firestore.collection("folders").document(folderId).collection("notes").whereField("userId", isEqualTo: userId).addSnapshotListener { noteSnapshot, error in
            if let error = error {
                print("Error fetching notes in folder \(folderId): \(error)")
                completion([])
                return
            }

            let folderNotes = noteSnapshot?.documents.compactMap { noteDocument -> Note? in
                try? noteDocument.data(as: Note.self)
            } ?? []

            completion(folderNotes)
        }
    }



    func addFolder(name: String, parentId: String?, completion: @escaping (Bool) -> Void) {
        guard let userId = auth.currentUser?.uid else { completion(false); return }
        let newFolder = FileItem(id: UUID().uuidString, userId: userId, name: name, isFolder: true, parentID: parentId, children: [])
        do {
                try firestore.collection("folders").document(newFolder.id).setData(from: newFolder) { error in
                    completion(error == nil)
                }
        } catch {
            completion(false)
        }
    }
    
    func addNote(title: String, folderId: String?, completion: @escaping (Bool) -> Void) {
        guard let userId = auth.currentUser?.uid else { completion(false); return }
        let newNote = Note(id: UUID().uuidString, name: title, userId: userId, parentID: folderId ?? "", content: "", createdAt: Date(), updatedAt: Date(), attributedContent: nil)
        
        do {
            if let folderId = folderId {
                let folderRef = self.firestore.collection("folders").document(folderId).collection("notes").document(newNote.id)
                try folderRef.setData(from: newNote) { error in
                    completion(error == nil)
                    if let error = error {
                        print("Error adding note to folder: \(error)")
                    }
                }
            } else {
                try firestore.collection("notes").document(newNote.id).setData(from: newNote) { error in
                    completion(error == nil)
                    if let error = error {
                        print("Error adding note: \(error)")
                    }
                }
            }
        } catch {
            completion(false)
            print("Error adding note: \(error)")
        }
    }

    
    func updateNote(_ updatedNote: Note, completion: @escaping (Bool) -> Void) {
        var updatedNoteData: [String: Any] = [
            "id": updatedNote.id,
            "name": updatedNote.name,
            "userId": updatedNote.userId,
            "parentID": updatedNote.parentID,
            "content": updatedNote.content,
            "createdAt": updatedNote.createdAt,
            "updatedAt": updatedNote.updatedAt
        ]

        if let attributedContent = updatedNote.attributedContent {
            updatedNoteData["attributedContent"] = attributedContent
        }

        // Check if parentID is not empty
        if !updatedNote.parentID.isEmpty {
            // Update note within a folder
            let noteRef = firestore.collection("folders").document(updatedNote.parentID).collection("notes").document(updatedNote.id)
            noteRef.setData(updatedNoteData, merge: true) { error in
                if let error = error {
                    print("Error updating note in folder \(updatedNote.parentID): \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } else {
            // Update note directly (not in a folder)
            let noteRef = firestore.collection("notes").document(updatedNote.id)
            noteRef.setData(updatedNoteData, merge: true) { error in
                if let error = error {
                    print("Error updating note: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    

}

extension FileItem {
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "userId": userId,
            "name": name,
            "isFolder": isFolder,
            "parentID": parentID ?? "",
            "children": children?.map { $0.toDictionary() } ?? [],
            "note": note?.map { $0.toDictionary() }  ?? []
        ]
    }
}

extension Note {
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "userId": userId,
            "parentID": parentID,
            "content": content,
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt),
            "attributedContent": attributedContent ?? Data()
        ]
    }
}
