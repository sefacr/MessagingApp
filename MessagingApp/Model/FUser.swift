//
//  FUser.swift
//  MessagingApp
//
//  Created by Sefa Acar on 6.05.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FUser {
    let objectId: String
    var email: String
    var fullName: String
    var avatar: String
    var phoneNumber: String
    var countryCode: String
    var isOnline: Bool
    var contacts: [String]
    
    init(_objectId: String, _email: String, _fullName: String, _avatar: String, _phoneNumber: String, _countryCode: String) {
        objectId = _objectId
        email = _email
        fullName = _fullName
        avatar = _avatar
        isOnline = true
        phoneNumber = _phoneNumber
        countryCode = _countryCode
        contacts = []
    }
    
    init(_dictionary: NSDictionary) {
        objectId = _dictionary [kOBJECTID] as! String
        
        if let mail = _dictionary[kEMAIL] {
            email = mail as! String
        } else {
            email = ""
        }
        
        if let fname = _dictionary [kFULLNAME] {
            fullName = fname as! String
        } else {
            fullName = ""
        }
        
        if let avat = _dictionary[kAVATAR] {
            avatar = avat as! String
        } else {
            avatar = ""
        }
        
        if let onl = _dictionary[kISONLINE] {
            isOnline = onl as! Bool
        } else {
            isOnline = false
        }
        
        if let phone = _dictionary[kPHONE] {
        phoneNumber = phone as! String
        } else {
            phoneNumber = ""
        }
        
        if let countryC = _dictionary[kCOUNTRYCODE] {
            countryCode = countryC as! String
        } else {
            countryCode = ""
        }
    
        if let cont = _dictionary[kCONTACT] {
            contacts = cont as! [String]
        } else {
            contacts = []
        }
        
        
    }



    //MARK: Returning current user funcs
    class func currentId()-> String {
        return Auth.auth().currentUser!.uid
    }

    class func currentUser () -> FUser? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                return FUser.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }

    //MARK: Login function
     class func loginUserWithEmail(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (firUser, error) in
            if error != nil {
                completion(error)
                return
            } else {
                //get user from firebase and save locally
                fetchCurrentUserFromFirestore(userId: firUser!.user.uid)
                completion(error)
            }
        })
    }

    
    //MARK: Register functions
    class func registerUserWithEmail(email: String, password: String, fullName: String, avatar: String, phoneNumber: String, countryCode: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (firuser, error) in
            if error != nil {
                completion(error)
                return
            }
            
            let fUser = FUser(_objectId: firuser!.user.uid, _email: firuser!.user.email!, _fullName: fullName, _avatar: avatar, _phoneNumber: phoneNumber, _countryCode: countryCode)
            saveUserLocally(fUser: fUser)
            saveUserToFirestore(fUser: fUser)
            completion(error)
        })
    }


    //MARK: LogOut func
    class func logOutCurrentUser(completion: @escaping (_ success: Bool) -> Void) {
        userDefaults.removeObject(forKey: kCURRENTUSER)
        userDefaults.synchronize()
        do {
            try Auth.auth().signOut() 
            completion (true)
        } catch let error as NSError {
            completion (false)
            print(error.localizedDescription)
        }
    }

    
    //MARK: Delete user
    class func deleteUser(completion: @escaping (_ error: Error?) -> Void) { 
        let user = Auth.auth().currentUser
        user?.delete(completion: { (error) in
            completion(error)
        })
    }
} //end of class funcs





    //MARK: Save user funcs
func saveUserToFirestore(fUser: FUser) {
    collectionReference(.User).document(fUser.objectId).setData(userDictionaryFrom(user: fUser) as! [String: Any]) { (error) in
        print("error is \(error?.localizedDescription)")
    }
}

func saveUserLocally(fUser: FUser) {
    UserDefaults.standard.set(userDictionaryFrom(user: fUser), forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}

//MARK: Fetch User funcs
//New firestore
func fetchCurrentUserFromFirestore(userId: String) {
    collectionReference(.User).document(userId).getDocument { (snapshot, error) in
    guard let snapshot = snapshot else { return }
    if snapshot.exists {
        UserDefaults.standard.setValue(snapshot.data() as! NSDictionary, forKeyPath: kCURRENTUSER)
        UserDefaults.standard.synchronize()
        }
    }
}


func fetchCurrentUserFromFirestore(userId: String, completion: @escaping (_ user: FUser?)->Void) {
    collectionReference(.User).document(userId).getDocument { (snapshot, error) in
        guard let snapshot = snapshot else { return }
        if snapshot.exists {
            let user = FUser(_dictionary: snapshot.data()! as NSDictionary)
            completion (user)
        } else {
            completion (nil)
        }
    }
}



//MARK: Helper funcs
func userDictionaryFrom(user: FUser) -> NSDictionary {
    return NSDictionary(objects: [user.objectId, user.email, user.fullName, user.avatar, user.contacts, user.isOnline, user.phoneNumber, user.countryCode], forKeys: [kOBJECTID as NSCopying, kEMAIL as NSCopying, kNAME as NSCopying, kAVATAR as NSCopying, kCONTACT as NSCopying, kISONLINE as NSCopying, kPHONE as NSCopying, kCOUNTRYCODE as NSCopying])
}

func getUsersFromFirestore(withIds: [String], completion: @escaping (_ usersArray: [FUser]) -> Void) {
    var count = 0
    var usersArray: [FUser] = []
    
    //go through each user and download it from firestore
    for userId in withIds {
        collectionReference(.User).document(userId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            if snapshot.exists {
                let user = FUser(_dictionary: snapshot.data() as! NSDictionary)
                count += 1
                //dont add if its current user
                if user.objectId != FUser.currentId() {
                    usersArray.append(user)
                }
            } else {
                completion (usersArray)
            }
            if count == withIds.count {
                //we have finished, return the array
                completion(usersArray)
            }
        }
    }
}



func updateCurrentUserInFirestore(withValues: [String: Any], completion: @escaping (_ error: Error?) -> Void) {
    if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
        var tempWithValues = withValues
        let currentUserId = FUser.currentId()
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(tempWithValues)
        collectionReference(.User).document(currentUserId).updateData(withValues) { (error) in
            if error != nil {
                completion(error)
                return
            }
            //update current user
            UserDefaults.standard.setValue(userObject, forKeyPath: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            completion(error)
        }
    }
}

