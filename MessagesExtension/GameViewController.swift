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
    var playerId: String!
    var draggable: Bool!
    var opponent: String!
    
    var photoUrl: String!
    var answer: String!
    var guesses: Int!
    var opponentGuesses: Int!
    var games: Int!
    var player: AVAudioPlayer?
    var bgm: AVAudioPlayer?
    weak var delegate: GameViewControllerDelegate?
    
    static let storyboardIdentifier = "GameViewController"
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
        if let bgm = bgm {
            bgm.stop()
        }
    }
    
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
        guard let BGMURL = Bundle.main.url(forResource: "game",withExtension: "mp3") else {
            
            return
        }
        do {
            bgm = try AVAudioPlayer(contentsOf: BGMURL)
            bgm?.prepareToPlay()
        }
        catch {
            return
        }

        playBGM()
      
        let background = UIImageView(image: UIImage(named: "background-design60"))
        background.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(background)

        // display image
        getImage()
        displayHeader()
        
        
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
                tile.isUserInteractionEnabled = true
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
    
    func displayHeader() {
        let letterHeight = ScreenHeight * 0.05
        var letterimage = UIImage()
        if self.draggable == false {
         letterimage = UIImage(named: "friend.png")!
        } else {
         letterimage = UIImage(named: "yourturn.png")!
        }
        let letterview = UIImageView(frame: CGRect(x: 0, y: 106, width: ScreenWidth, height: letterHeight))
        letterview.contentMode = UIViewContentMode.scaleAspectFit
        
        letterview.image = letterimage
        self.view.addSubview(letterview)
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
    func playBGM() {
        if let bgm = bgm {
            if bgm.isPlaying {
                bgm.currentTime = 0
            } else {
                bgm.play()
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
        
        createParticles()
    }
    func checkForSuccess() {
        for targetView in targets {
            //no success, bail out
            if !targetView.isMatched {
                self.guesses = self.guesses + 1
                NSLog("guesses = \(self.guesses)")
                self.reset()
                return
            }
        }
        // if entire game is over
        // clear view, addSubview, with player that won, player num guesses, and btn for rematch 
        // else stuff below
        let bannerHeight = ScreenHeight * 0.1
        var bannerimage = UIImage()
        
            bannerimage = UIImage(named: "goodjob.png")!
        let bannerview = UIImageView(frame: CGRect(x: -ScreenWidth, y: ScreenHeight/2, width: ScreenWidth, height: bannerHeight))
        bannerview.contentMode = UIViewContentMode.scaleAspectFit
        
        bannerview.image = bannerimage
        self.view.addSubview(bannerview)
        UIView.animate(withDuration: 0.30,
                       delay:0.00,
                       //4
            animations: {
                bannerview.center = CGPoint(x: self.ScreenWidth * 0.5, y: self.ScreenHeight/2)
                bannerview.transform = CGAffineTransform.identity
            },
            //5
            completion: {
                (value:Bool) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // your function here
                    UIView.animate(withDuration: 0.30,
                                   delay:0.00,
                                   //4
                        animations: {
                            bannerview.center = CGPoint(x: self.ScreenWidth * 1.5, y: self.ScreenHeight/2)
                            bannerview.transform = CGAffineTransform.identity
                        },
                        //5
                        completion: {
                            (value:Bool) in

                            self.gameover()
                    })
                }

                        })


        
       
        
    }
    
    func gameover(){
        self.guesses = self.guesses + 1
        let prefs = UserDefaults.standard
        prefs.setValue("true", forKey: self.answer)
        games = games + 1
        if (games == 2) {
            //compose win message
            self.delegate?.presentWinViewController(self, playerId: playerId, opponent: opponent, guesses: guesses, opponentGuesses: opponentGuesses)
        } else {
            self.delegate?.presentSendPicViewController(self)
        }

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
        
    func createParticles() {
        let particleEmitter = CAEmitterLayer()
        
        particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: view.center.y)
        particleEmitter.emitterShape = kCAEmitterLayerLine
        particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        
        let red = makeEmitterCell()
        
        particleEmitter.emitterCells = [red]
        
        view.layer.addSublayer(particleEmitter)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // your function here
        
          particleEmitter.setValue(0, forKeyPath: "emitterCells.cell.birthRate")
        }
    }
    
    func makeEmitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.name = "cell"
        cell.birthRate = 100
        cell.lifetime = 0.75
        cell.blueRange = 0.33
        cell.blueSpeed = -0.33
        
        //8
        cell.velocity = 160
        cell.velocityRange = 40
        
        //9
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.2
        
        //10
        cell.emissionRange = CGFloat(M_PI*2)
        
        cell.contents = UIImage(named: "particle.png")?.cgImage
        return cell
    }
    
}

protocol GameViewControllerDelegate: class {
    func presentSendPicViewController(_ controller:GameViewController)
    func presentWinViewController(_ controller:GameViewController, playerId: String, opponent: String, guesses: Int, opponentGuesses: Int)
}

