//
//  User.swift
//  Grocr-JP
//
//  Created by Jay P. Hayes on 12/12/16.
//  Copyright © 2016 Jay P. Hayes. All rights reserved.
//

import Foundation
import Firebase


struct User {
    let uid: String
    let email: String

    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }

    
}
