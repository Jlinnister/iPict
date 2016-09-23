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
import AVFoundation
private var tiles = [TileView]()
private var targets = [TargetView]()



class GameViewController: UIViewController {
    
    var ScreenWidth = UIScreen.main.bounds.size.width
    var ScreenHeight = UIScreen.main.bounds.size.height
    var level: Level!
    var playerId: String!
    var draggable: Bool!
    
    var photoUrl: String!
    var answer: String!
    var wrongGuess = 0
    var games: Int!
    var player: AVAudioPlayer?
    weak var delegate: GameViewControllerDelegate?
    
    static let storyboardIdentifier = "GameViewController"
    
    func dealRandomTile() {
        guard let fileURL = Bundle.main.url(forResource: "UI_Click",withExtension: "wav") else {
            
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: fileURL)
            player?.prepareToPlay()
        }
        catch {
            return
        }

      
        let background = UIImageView(image: UIImage(named: "background-design60"))
        background.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(background)

        // display image
        getImage()
        
        //assert(level.answer.count > 0, "no level loaded")
        
        let tileSide = ceil((ScreenWidth * 0.9 - 5 * 5) / 6)
        let xOffset = (ScreenWidth * 0.05) + tileSide / 2 - 2.5
        

        targets = []
        let count = CGFloat(Array(self.answer.characters).count)
        let targetOffset = xOffset + (6 - count) * (tileSide + 5)/2
        //create targets
        for (index, letter) in Array(self.answer.uppercased().characters).enumerated() {
            
                let target = TargetView(letter: letter, sideLength: tileSide)
                target.center = CGPoint(x: targetOffset + CGFloat(index)*(tileSide + 5),y: ScreenHeight/4*3-tileSide-30)
                self.view.addSubview(target)
                targets.append(target)
            
        }
        
        //adjust for tile center (instead of the tile's origin)
        let letterSet: [Character] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        var tileSet = Array(self.answer.uppercased().characters)
        
        while tileSet.count < 12 {
            tileSet.append(letterSet[Int(arc4random_uniform(UInt32(26)))])
        }
        
        var randomTiles: [Character] = []
        while randomTiles.count < 12 {
            let ind = Int(arc4random_uniform(UInt32(tileSet.count)))
            randomTiles.append(tileSet[ind])
            tileSet.remove(at: ind)
        }
        
        for (index, letter) in randomTiles.map({ (value: Character)-> String in
            return String(value)
            }).enumerated()
            //3
            {
                var tile: TileView
            if index < 6 {
                let center = CGPoint(x: xOffset + CGFloat(index)*(tileSide + 5),y: ScreenHeight/4*3)
                tile = TileView(letter: letter, sideLength: tileSide, origin: center,index: -1)
                
            } else {
                let center = CGPoint(x: xOffset + CGFloat(index - 6)*(tileSide + 5),y: ScreenHeight/4*3 + tileSide + 20)
                tile = TileView(letter: letter, sideLength: tileSide, origin: center,index: -1)
            }
                tile.center = tile.origin
                tile.dragDelegate = self
                //4
                self.view.addSubview(tile)
                tiles.append(tile)
                if self.draggable == false {
                //tile.isUserInteractionEnabled = false
                }
            }
    }
    func getImage() {
        let storageRef = FIRStorage.storage().reference(forURL: "gs://ipict-835f2.appspot.com")
        let imageRef = storageRef.child("images/" + self.answer + ".jpg")
        imageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            let image = UIImage(data: data!)
            let imgview = UIImageView(frame: CGRect(x: self.ScreenWidth * 0.25, y: self.ScreenHeight * 0.15 + 86, width: self.ScreenWidth * 0.5, height: self.ScreenWidth * 0.5))
            imgview.layer.cornerRadius = 10.0;
            imgview.clipsToBounds = true
            imgview.image = image
            self.view.addSubview(imgview)
        }
    }
    
    func playEffect() {
        if let player = player {
            if player.isPlaying {
                player.currentTime = 0
            } else {
                player.play()
            }
        }
    }


    
}
extension GameViewController:TileDragDelegateProtocol {
    //a tile was dragged, check if matches a target
    func tileView(tileView: TileView, didDragToPoint point: CGPoint) {
        var targetView: TargetView?
        if tileView.index > -1 {
           targets[tileView.index].isMatched = false
           targets[tileView.index].isOccupied = false
        }
        for (index,tv) in targets.enumerated() {
            if tv.frame.contains(point) {
                
                targetView = tv
                tv.isOccupied = true
                for tile in tiles {
                    if tile.index == index {
                        self.returnTile(tileView: tile)
                    }
                }
                tileView.index = index
                
                break
            } else {
                //return to origin
                self.returnTile(tileView: tileView)
            }
        }
        if let targetView = targetView {
            
            //2 check if letter matches
            if String(targetView.letter) == tileView.letter {
                
                self.placeTile(tileView: tileView, targetView: targetView)
                //more stuff to do on success here
                playEffect()
                tileView.isMatched = true
                targetView.isMatched = true
                
                
            } else {
                targetView.isMatched = false
                //4
                self.placeTile(tileView: tileView, targetView: targetView)
                playEffect()
                //more stuff to do on failure here
            }
            for target in targets {
                if !target.isOccupied {
                    return
                }
            }
            self.checkForSuccess()
        }
    }
    func returnTile(tileView: TileView){
      tileView.isMatched = false
        tileView.index = -1
        UIView.animate(withDuration: 0.10,
                       delay:0.00,
                       options:UIViewAnimationOptions.curveEaseOut,
                       //4
            animations: {
                tileView.center = tileView.origin
                tileView.transform = CGAffineTransform.identity
            },
            //5
            completion: {
                (value:Bool) in
            })
    }
    func placeTile(tileView: TileView, targetView: TargetView) {
        //1
        
        tileView.isUserInteractionEnabled = true
        
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
                targetView.isHidden = false
        })
    }
    func checkForSuccess() {
        for targetView in targets {
            //no success, bail out
            if !targetView.isMatched {
                self.wrongGuess = self.wrongGuess + 1
                NSLog("WrongGuess = \(self.wrongGuess)")
                self.reset()
                return
            }
        }
        NSLog("Game Over!")
        let prefs = UserDefaults.standard
        prefs.setValue("true", forKey: self.answer)
        games = games + 1
        self.delegate?.presentSendPicViewController(self)
    }
    
    func reset(){
        for tile in tiles {
            self.returnTile(tileView: tile)
        }
        for target in targets {
            target.isMatched = false
            target.isOccupied = false
        }
    }
    
}

protocol GameViewControllerDelegate: class {
    func presentSendPicViewController(_ controller:GameViewController)
}

