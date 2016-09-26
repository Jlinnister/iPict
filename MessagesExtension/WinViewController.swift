//
//  WinViewController.swift
//  iPict
//
//  Created by Jeff Lin on 23/09/2016.
//  Copyright © 2016 iPict. All rights reserved.
//

import Foundation
import UIKit

class WinViewController: UIViewController {
    
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


    
    }
    
    @IBAction func buttonRematchPressed(_ sender: AnyObject) {
        self.delegate?.winViewControllerDidPressRematch(self)
    }
}

protocol WinViewControllerDelegate: class {
    func winViewControllerDidPressRematch(_ controller: WinViewController)
}
