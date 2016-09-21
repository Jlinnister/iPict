//
//  TileView.swift
//  iPict
//
//  Created by Jim Wang on 9/20/16.
//  Copyright © 2016 iPict. All rights reserved.
//

import Foundation
import UIKit

//1
class TileView:UIImageView {
    //2
    var letter: String
    private var xOffset: CGFloat = 0.0
    private var yOffset: CGFloat = 0.0
    //3
    var isMatched: Bool = false
    
    //4 this should never be called
    required init(coder aDecoder:NSCoder) {
        fatalError("use init(letter:, sideLength:")
    }
    
    //5 create a new tile for a given letter
    init(letter:String, sideLength:CGFloat) {
        self.letter = letter
        
        //the tile background
        let image = UIImage(named: "tiles/\(self.letter).png")!
        
        //superclass initializer
        //references to superview's "self" must take place after super.init
        super.init(image: image)
        
        //6 resize the tile
        let scale = sideLength / image.size.width
        self.frame = CGRect(x: 0, y: 0, width: image.size.width*scale, height: image.size.height*scale)
        self.isUserInteractionEnabled = true
        //more initialization here
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let point = touch.location(in: self.superview)
            xOffset = point.x - self.center.x
            yOffset = point.y - self.center.y

        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let point = touch.location(in: self.superview)
            self.center = CGPoint(x: point.x - xOffset,y: point.y - yOffset)

        }
    }
    //2
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesMoved(touches, with: event)
    }
    //3
    
}