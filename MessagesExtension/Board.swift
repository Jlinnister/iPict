//
//  Board.swift
//  iPict
//
//  Created by Jeff Lin on 20/09/2016.
//  Copyright © 2016 iPict. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class Board {
    var photoUrl: String!
    var wordLength: Int!
    var answer: String!
    var randomNumber: Int!
    
    init () {
        self.randomNumber = Int(arc4random_uniform(UInt32(Constants.Filenames.count)))
        self.answer = Constants.Filenames[self.randomNumber]
        self.wordLength = Constants.Filenames[self.randomNumber].characters.count
    }
    
//    func image {
//        DispatchQueue.global().async {
//            if (board._photoUrl != nil) {
//                print(board._photoUrl)
//                do {
//                    let data = try Data(contentsOf: board._photoUrl!)
//                    DispatchQueue.global().sync {
//                        self.imageTest.image = UIImage(data: data)
//                    }
//                } catch {
//                    //errors
//                }
//            }
//        }
//    }
    
    func getDataFromUrl(image: UIImageView) {
        image.image = UIImage(named: "blank")
        let storageRef = FIRStorage.storage().reference(forURL: "gs://ipict-835f2.appspot.com")
        let imageRef = storageRef.child("images/\(Constants.Filenames[self.randomNumber]).jpg")
        imageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            self.photoUrl = imageRef.fullPath
            image.image = UIImage(data: data!)
        }
    }
}
