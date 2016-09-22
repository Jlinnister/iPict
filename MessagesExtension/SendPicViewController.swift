//
//  SendPicViewController.swift
//  iPict
//
//  Created by Jeff Lin on 21/09/2016.
//  Copyright © 2016 iPict. All rights reserved.
//

import UIKit

class SendPicViewController: UIViewController {

    // MARK: Properties
    weak var delegate: SendPicViewControllerDelegate?
    
    static let storyboardIdentifier = "SendPicViewController"
    
    var ScreenWidth = UIScreen.main.bounds.size.width
    var ScreenHeight = UIScreen.main.bounds.size.height - 86
    var images: [UIImageView] = []
    var boards: [Board] = []
    var btns: [UIButton] = []
    
    var playerId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = UIImageView(image: UIImage(named: "background-design60"))
        background.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(background)
        
        presentImages()

    }
    
    func presentImages() {
        
        for index in 1...4 {
            let img = UIImageView()
            let board = Board()
            board.getDataFromUrl(image: img)
            let btn = UIButton(type: UIButtonType.custom) as UIButton
            //            btn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            //            btn.setImage(board.photo, for: UIControlState.normal)
            btn.tag = index - 1
            btn.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            boards.append(board)
            images.append(img)
            btns.append(btn)
        }
        
        for (index, img) in images.enumerated() {
            let imgDim = ScreenHeight * 0.9 / 4 - 20.0
            var yOffset = (ScreenHeight - (4 * (imgDim + 20))) / 2.0
            yOffset += imgDim / 2.0
            
            img.frame = CGRect(x: 0, y: 0, width: imgDim, height: imgDim)
            img.center = CGPoint(x: ScreenWidth / 2.0, y: yOffset + CGFloat(index)*(imgDim + 20) + 86)
            
            self.view.addSubview(img)
        }
        
        for (index, img) in btns.enumerated() {
            let imgDim = ScreenHeight * 0.9 / 4 - 20.0
            var yOffset = (ScreenHeight - (4 * (imgDim + 20))) / 2.0
            yOffset += imgDim / 2.0
            
            img.frame = CGRect(x: 0, y: 0, width: imgDim, height: imgDim)
            img.center = CGPoint(x: ScreenWidth / 2.0, y: yOffset + CGFloat(index)*(imgDim + 20) + 86)
            
            self.view.addSubview(img)
        }
    }
    
    func buttonPressed(sender: UIButton) {
        print("Button Tapped")
        self.delegate?.sendPicViewController(self, didGetBoard: boards[sender.tag])
    }
}

protocol SendPicViewControllerDelegate: class {
    func sendPicViewController(_ controller: SendPicViewController, didGetBoard board: Board)
}

