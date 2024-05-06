//
//  FirebaseCollectionReference.swift
//  MessagingApp
//
//  Created by Sefa Acar on 6.05.2024.
//

import Foundation
import FirebaseFirestore
import MessageUI
import CoreTelephony

enum FirebaseCollectionReference: String {
    case Message
    case RecentChat
    case User
    case Group
    case Call
    case Typing
}

func collectionReference(_ collectionReference: FirebaseCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
