//
//  StartViewController.swift
//  iPict
//
//  Created by Jeff Lin on 21/09/2016.
//  Copyright © 2016 iPict. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
class StartViewController: UIViewController {
    
    // MARK: Properties
    weak var delegate: StartViewControllerDelegate?
    
    static let storyboardIdentifier = "StartViewController"
    var clickplayer: AVAudioPlayer?
    var ScreenWidth = UIScreen.main.bounds.size.width
    var ScreenHeight = UIScreen.main.bounds.size.height - 86
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    @IBAction func buttonPlayPressed(_ sender: AnyObject) {
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

        self.delegate?.startViewControllerDidPressPlay(self)
    }
}

protocol StartViewControllerDelegate: class {
    func startViewControllerDidPressPlay(_ controller: StartViewController)
}
