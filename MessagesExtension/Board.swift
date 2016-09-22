//
//  Board.swift
//  iPict
//
//  Created by Jeff Lin on 20/09/2016.
//  Copyright © 2016 iPict. All rights reserved.
//

import Foundation
import Messages
import Firebase
import FirebaseStorage

class Board {
    var photoUrl: String!
    var wordLength: Int!
    var answer: String!
    var randomNumber: Int!
    var image: UIImage!
    
    init () {
        self.randomNumber = Int(arc4random_uniform(UInt32(Constants.Filenames.count)))
        self.answer = Constants.Filenames[self.randomNumber]
        self.wordLength = Constants.Filenames[self.randomNumber].characters.count
    }
    
//    init?(message: MSMessage?) {
//        guard let messageURL = message?.url else { return nil }
//        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems else { return nil }
//        
//        self.init(queryItems: queryItems)
//    }
    
    func getDataFromUrl(image: UIImageView) {
        let storageRef = FIRStorage.storage().reference(forURL: "gs://ipict-835f2.appspot.com")
        let imageRef = storageRef.child("images/\(Constants.Filenames[self.randomNumber]).jpg")
        imageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            self.photoUrl = imageRef.fullPath
            self.image = UIImage(data: data!)
            image.image = UIImage(data: data!)
        }
    }
}

extension Board {
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        items.append(URLQueryItem(name: "Opponent", value: "x"))
        items.append(URLQueryItem(name: "Board", value: "y"))
        
        return items
    }

}
