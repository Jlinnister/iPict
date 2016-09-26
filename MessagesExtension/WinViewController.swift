//
//  WinViewController.swift
//  iPict
//
//  Created by Jeff Lin on 23/09/2016.
//  Copyright © 2016 iPict. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class WinViewController: UIViewController {
    var clickplayer: AVAudioPlayer!
    var playerId: String!
    var opponent: String!
    var guesses: Int!
    var opponentGuesses: Int!
    
    // MARK: Properties
    weak var delegate: WinViewControllerDelegate?
    
    static let storyboardIdentifier = "WinViewController"
    
    var ScreenWidth = UIScreen.main.bounds.size.width
    var ScreenHeight = UIScreen.main.bounds.size.height - 86
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("win: \(playerId) Player One:\(guesses)")
        print("win: \(opponent) Player Two:\(opponentGuesses)")
        
        let imageView = UIImageView(frame: CGRect(x:ScreenWidth * 0.1, y: 136 + ScreenHeight * 0.05, width: ScreenWidth * 0.8 ,height: ScreenHeight/4))
        imageView.backgroundColor = UIColor(red: 219/255, green: 255/255, blue: 241/255, alpha: 1)
        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
        
       
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.8
        imageView.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        imageView.layer.shadowRadius = 15.0
        imageView.layer.masksToBounds = false
        self.view.addSubview(imageView)
        
        let imageView2 = UIImageView(frame: CGRect(x:ScreenWidth * 0.1, y: (ScreenHeight + 172)/2 - 20, width: ScreenWidth * 0.8 ,height: ScreenHeight/4))
        imageView2.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 204/255, alpha: 1)
        imageView2.layer.cornerRadius = 20.0
        imageView2.clipsToBounds = true
        
        
        imageView2.layer.shadowColor = UIColor.black.cgColor
        imageView2.layer.shadowOpacity = 0.8
        imageView2.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        imageView2.layer.shadowRadius = 15.0
        imageView2.layer.masksToBounds = false
        self.view.addSubview(imageView2)

        
        
        
        let letterHeight = ScreenHeight * 0.05
        let letterimage = UIImage(named: "result.png")!
        
        let letterview = UIImageView(frame: CGRect(x: 0, y: 106, width: ScreenWidth, height: letterHeight))
        letterview.contentMode = UIViewContentMode.scaleAspectFit
        
        letterview.image = letterimage
        self.view.addSubview(letterview)
        
        
        let p1Height = ScreenHeight * 0.05
        let p1image = UIImage(named: "player1.png")!
        
        let p1view = UIImageView(frame: CGRect(x: 0, y: 156 + letterHeight, width: ScreenWidth, height: p1Height))
        p1view.contentMode = UIViewContentMode.scaleAspectFit
        
        p1view.image = p1image
        self.view.addSubview(p1view)
        
        
        let guessHeight = ScreenHeight * 0.04
        let guessimage = UIImage(named: "guess.png")!
        
        let guessview = UIImageView(frame: CGRect(x: 0, y: 166 + letterHeight + p1Height, width: ScreenWidth, height: guessHeight))
        guessview.contentMode = UIViewContentMode.scaleAspectFit
        
        guessview.image = guessimage
        self.view.addSubview(guessview)
        
        var numberImg = String(guesses)
        let numberHeight = ScreenHeight * 0.04
        let count = CGFloat(Array(numberImg.characters).count)
        let numberOffset = (count - 1) * numberHeight/2
        for (index, number) in Array(numberImg.characters).enumerated() {
            let numberimage = UIImage(named: "\(number).png")!
        
        let numberview = UIImageView(frame: CGRect(x: -numberOffset + CGFloat(index) * numberHeight , y: 186 + letterHeight + p1Height + guessHeight, width: ScreenWidth, height: numberHeight))
        numberview.contentMode = UIViewContentMode.scaleAspectFit
        
        numberview.image = numberimage
        self.view.addSubview(numberview)

        }
        
        
        let p2Height = ScreenHeight * 0.05
        let p2image = UIImage(named: "player2.png")!
        
        let p2view = UIImageView(frame: CGRect(x: 0, y: (ScreenHeight + 172)/2, width: ScreenWidth, height: p2Height))
        p2view.contentMode = UIViewContentMode.scaleAspectFit
        
        p2view.image = p2image
        self.view.addSubview(p2view)

        
        let guess2view = UIImageView(frame: CGRect(x: 0, y: (ScreenHeight + 172)/2 + p2Height + 10, width: ScreenWidth, height: guessHeight))
        guess2view.contentMode = UIViewContentMode.scaleAspectFit
        
        guess2view.image = guessimage
        self.view.addSubview(guess2view)
        
        
        var number2Img = String(opponentGuesses)
        let number2Height = ScreenHeight * 0.04
        let count2 = CGFloat(Array(number2Img.characters).count)
        let number2Offset = (count2 - 1) * number2Height/2
        for (index, number) in Array(number2Img.characters).enumerated() {
            let number2image = UIImage(named: "\(number).png")!
            
            let number2view = UIImageView(frame: CGRect(x: -number2Offset + CGFloat(index) * number2Height , y: (ScreenHeight + 172)/2 + p2Height + guessHeight + 30, width: ScreenWidth, height: numberHeight))
            number2view.contentMode = UIViewContentMode.scaleAspectFit
            
            number2view.image = number2image
            self.view.addSubview(number2view)
            
        }

        
        var crownPos: CGFloat?
       
        if guesses < opponentGuesses {
            crownPos = 126 + ScreenHeight * 0.05
        } else if guesses > opponentGuesses {
            crownPos = (ScreenHeight + 172)/2 - 10
        } else {
            crownPos = -300
        }
        
        let crownHeight = ScreenHeight * 0.1
        let crownimage = UIImage(named: "crown.png")!
        
        let crownview = UIImageView(frame: CGRect(x:ScreenWidth * 0.04, y: crownPos!, width: crownHeight, height: crownHeight))
        guessview.contentMode = UIViewContentMode.scaleAspectFit
        
        crownview.image = crownimage
        self.view.addSubview(crownview)

        


    
    }
    
    @IBAction func buttonRematchPressed(_ sender: AnyObject) {
        guard let clickURL = Bundle.main.url(forResource: "click",withExtension: "wav") else {
            
            return
        }
        do {
            clickplayer = try AVAudioPlayer(contentsOf: clickURL)
            clickplayer.prepareToPlay()
        }
        catch {
            return
        }
        clickplayer.play()

        self.delegate?.winViewControllerDidPressRematch(self)
    }
}

protocol WinViewControllerDelegate: class {
    func winViewControllerDidPressRematch(_ controller: WinViewController)
}
