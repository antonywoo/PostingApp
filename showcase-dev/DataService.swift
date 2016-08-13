//
//  DataService.swift
//  showcase-dev
//
//  Created by Cex on 13/08/2016.
//  Copyright © 2016 newmediatechies. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = FIRDatabase.database().reference()   //goes to get app url from google plist


class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = URL_BASE
    private var _REF_USERS = URL_BASE.child("users")
    private var _REF_POSTS = URL_BASE.child("posts")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>){
        //creates user path to location id in Firebase
        REF_USERS.child(uid).updateChildValues(user) //update values instead of setValues
    }
}
