//
//  Extension.swift
//  NotesTaking
//
//  Created by Taliya Meyswara on 25/06/24.
//

import Foundation
import Combine
import FirebaseFirestore
    

extension String{    
    var isEmptyOrWhiteSpace: Bool{
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension Query {
    func snapshotsPublisher() -> AnyPublisher<QuerySnapshot, Error> {
        Future { promise in
            self.addSnapshotListener { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let snapshot = snapshot {
                    promise(.success(snapshot))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

extension DocumentReference {
    func snapshotsPublisher() -> AnyPublisher<DocumentSnapshot, Error> {
        Future { promise in
            self.addSnapshotListener { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let snapshot = snapshot {
                    promise(.success(snapshot))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
