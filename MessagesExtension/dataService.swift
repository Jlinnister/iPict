//
//  dataServices.swift
//  iPict
//
//  Created by Jeff Lin on 19/09/2016.
//  Copyright © 2016 iPict. All rights reserved.
//

import Foundation

import Firebase
import FirebaseStorage

let STORAGE_BASE = FIRStorage.storage().reference()

class dataService {
    static let ds = dataService()
    
    private var _REF_IMAGES = STORAGE_BASE
    
    var REF_IMAGES : FIRStorageReference {
        return _REF_IMAGES
    }
}

