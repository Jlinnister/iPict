//
//  SendPicViewController.swift
//  iPict
//
//  Created by Jeff Lin on 21/09/2016.
//  Copyright © 2016 iPict. All rights reserved.
//

import UIKit
import AVFoundation

class SendPicViewController: UIViewController {

    // MARK: Properties
    weak var delegate: SendPicViewControllerDelegate?
    static let storyboardIdentifier = "SendPicViewController"

    var ScreenWidth = UIScreen.main.bounds.size.height / 16 * 9
    var ScreenHeight = UIScreen.main.bounds.size.height - 86
    var images: [UIImageView] = []
    var boards: [Board] = []
    var btns: [UIButton] = []
    var clickplayer: AVAudioPlayer?
    var playerId: String?
    var oldAnswer: String?
    var games: Int?
    var currentId: String?
    var guesses: Int?
    var opponentGuesses: Int?
    var parentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.height / 16 * 9, height: UIScreen.main.bounds.size.height))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = UIImageView(image: UIImage(named: "background-design60"))
        background.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(background)
        parentView.center = CGPoint(x:UIScreen.main.bounds.size.width/2, y:UIScreen.main.bounds.size.height/2)
        self.view.addSubview(parentView)
        presentImages()
    }

    func presentImages() {
        for index in 1...4 {
            let img = UIImageView()
            let board = Board()
            board.getDataFromUrl(image: img)
            let btn = UIButton(type: UIButtonType.custom) as UIButton
            btn.tag = index - 1
            btn.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            boards.append(board)
            images.append(img)
            btns.append(btn)
        }

        var letterimage = UIImage()
        if ( games! == 0) {
            letterimage = UIImage(named: "new.png")!
        } else {
            letterimage = UIImage(named: "challenge.png")!
        }
        displayHeader(letterimage: letterimage)
        displayFooter()

        for (index, img) in images.enumerated() {
            let imgDim = ScreenWidth * 0.9 / 2 - 20.0
            var xOffset = (ScreenWidth - (2 * (imgDim + 20))) / 2.0
            xOffset += imgDim / 2.0
            img.frame = CGRect(x: 0, y: 0, width: imgDim, height: imgDim)
            img.center = CGPoint(x: 10 + xOffset + CGFloat(index % 2)*(imgDim + 20), y: ScreenHeight + 20 - (xOffset + CGFloat(floor(Double(index/2)))*(imgDim + 20)))
            img.layer.cornerRadius = 10.0;
            img.clipsToBounds = true
            parentView.addSubview(img)
        }

        for (index, img) in btns.enumerated() {
            let imgDim = ScreenWidth * 0.9 / 2 - 20.0
            var xOffset = (ScreenWidth - (2 * (imgDim + 20))) / 2.0
            xOffset += imgDim / 2.0
            img.frame = CGRect(x: 0, y: 0, width: imgDim, height: imgDim)
            img.center = CGPoint(x: 10 + xOffset + CGFloat(index % 2)*(imgDim + 20), y: ScreenHeight + 20 - (xOffset + CGFloat(floor(Double(index/2)))*(imgDim + 20)))
            parentView.addSubview(img)
        }
    }

    func displayHeader(letterimage: UIImage) {
        let letterHeight = ScreenHeight * 0.075
        let letterview = UIImageView(frame: CGRect(x: 0, y: ScreenHeight/4, width: ScreenWidth, height: letterHeight))
        letterview.contentMode = UIViewContentMode.scaleAspectFit
        letterview.image = letterimage
        parentView.addSubview(letterview)
    }
    
    func displayFooter() {
        let letterHeight = ScreenHeight * 0.05
        let footerimage = UIImage(named: "select.png")
        let letterview = UIImageView(frame: CGRect(x: 0, y: ScreenHeight * 0.35, width: ScreenWidth, height: letterHeight))
        letterview.contentMode = UIViewContentMode.scaleAspectFit
        letterview.image = footerimage
        parentView.addSubview(letterview)
    }

    func buttonPressed(sender: UIButton) {
        guard let clickURL = Bundle.main.url(forResource: "click",withExtension: "wav") else {
            return
        }
        do {
            clickplayer = try AVAudioPlayer(contentsOf: clickURL)
            clickplayer?.prepareToPlay()
        }
        catch {
            return
        }
        clickplayer?.play()
        self.delegate?.sendPicViewController(self, didGetBoard: boards[sender.tag], oldAnswer: oldAnswer!)
    }
}

protocol SendPicViewControllerDelegate: class {
    func sendPicViewController(_ controller: SendPicViewController, didGetBoard board: Board, oldAnswer: String)
}
