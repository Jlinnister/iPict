//
//  GameController.swift
//  iPict
//
//  Created by Jim Wang on 9/20/16.
//  Copyright © 2016 iPict. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit
private var tiles = [TileView]()
private var targets = [TargetView]()
class GameController {
    var ScreenWidth = UIScreen.main.bounds.size.width
    var ScreenHeight = UIScreen.main.bounds.size.height
    var gameView: UIView!
    var level: Level!
    
    
    var photoUrl: String!
    var wordLength: Int!
    var answer: String!
    var randomNumber: Int!
    
    init () {
        self.randomNumber = Int(arc4random_uniform(UInt32(Constants.Filenames.count)))
        self.answer = Constants.Filenames[self.randomNumber]
        self.wordLength = Constants.Filenames[self.randomNumber].characters.count
    }
    
    func dealRandomAnagram() {
        //assert(level.answer.count > 0, "no level loaded")
        
        let tileSide = ceil(ScreenWidth * 0.9 / 5) - 20.0
        var xOffset = (ScreenWidth - (5 * (tileSide + 20))) / 2.0
        xOffset += tileSide / 2.0

        targets = []
        
        //create targets
        for (index, letter) in Array(self.answer.uppercased().characters).enumerated() {
            
                let target = TargetView(letter: letter, sideLength: tileSide)
                target.center = CGPoint(x: xOffset + CGFloat(index)*(tileSide + 20),y: ScreenHeight/4*3-tileSide-50)
                gameView.addSubview(target)
                targets.append(target)
            
        }
        
        //adjust for tile center (instead of the tile's origin)
               let answer: [String] = ["A","B","C","D","E","F","G","H","I","J"]
        for (index, letter) in answer.enumerated() {
            //3
            
                let tile = TileView(letter: letter, sideLength: tileSide)
            if index < 5 {
                tile.center = CGPoint(x: xOffset + CGFloat(index)*(tileSide + 20),y: ScreenHeight/4*3)
            } else {
                tile.center = CGPoint(x: xOffset + CGFloat(index - 5)*(tileSide + 20),y: ScreenHeight/4*3 + tileSide + 20)
            }
                tile.dragDelegate = self
            
            
                //4
                gameView.addSubview(tile)
            
                tiles.append(tile)
            
        }
    }
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
extension GameController:TileDragDelegateProtocol {
    //a tile was dragged, check if matches a target
    func tileView(tileView: TileView, didDragToPoint point: CGPoint) {
        var targetView: TargetView?
        for tv in targets {
            if tv.frame.contains(point) && !tv.isMatched {
                targetView = tv
                break
            }
            
        }
        if let targetView = targetView {
            
            //2 check if letter matches
            if String(targetView.letter) == tileView.letter {
            
                self.placeTile(tileView: tileView, targetView: targetView)
                //more stuff to do on success here
                
                self.checkForSuccess()
            } else {
                
                //4
                self.placeTile(tileView: tileView, targetView: targetView)
                
                //more stuff to do on failure here
            }
        }
    }
    
    func placeTile(tileView: TileView, targetView: TargetView) {
        //1
        targetView.isMatched = true
        tileView.isMatched = true
        
        //2
        tileView.isUserInteractionEnabled = true
        
        //3
        UIView.animate(withDuration: 0.10,
                                   delay:0.00,
                                   options:UIViewAnimationOptions.curveEaseOut,
                                   //4
            animations: {
                tileView.center = targetView.center
                tileView.transform = CGAffineTransform.identity
            },
            //5
            completion: {
                (value:Bool) in
                targetView.isHidden = true
        })
    }
    func checkForSuccess() {
        for targetView in targets {
            //no success, bail out
            if !targetView.isMatched {
                return
            }
        }
        NSLog("Game Over!")
    }
}
