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
        print("win: \(guesses)")
        print("win: \(opponentGuesses)")
        
        let label = UILabel(frame: CGRect(x:0, y:100, width: ScreenWidth, height: 20))
        label.textAlignment = NSTextAlignment.center
        label.text = "Round Over!"
        self.view.addSubview(label)
    }
    
    @IBAction func buttonRematchPressed(_ sender: AnyObject) {
        self.delegate?.winViewControllerDidPressRematch(self)
    }
}

protocol WinViewControllerDelegate: class {
    func winViewControllerDidPressRematch(_ controller: WinViewController)
}
