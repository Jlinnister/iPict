//
//  TargetView.swift
//  iPict
//
//  Created by Jim Wang on 9/20/16.
//  Copyright © 2016 iPict. All rights reserved.
//

import Foundation

import UIKit

class TargetView: UIImageView {
    var letter: Character
    var isMatched:Bool = false
    var isOccupied:Bool = false
    
    //this should never be called
    required init(coder aDecoder:NSCoder) {
        fatalError("use init(letter:, sideLength:")
    }
    
    init(letter:Character, sideLength:CGFloat) {
        self.letter = letter
        let image = UIImage(named: "tiles/blank.png")!
        super.init(image:image)
        
        let scale = sideLength / image.size.width
        self.frame = CGRect(x: 0, y: 0, width: image.size.width*scale, height: image.size.height*scale)
    }
}
