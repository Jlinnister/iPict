//
//  StartViewController.swift
//  iPict
//
//  Created by Jeff Lin on 21/09/2016.
//  Copyright © 2016 iPict. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
    
    // MARK: Properties
    weak var delegate: StartViewControllerDelegate?
    
    static let storyboardIdentifier = "StartViewController"
    
    var ScreenWidth = UIScreen.main.bounds.size.width
    var ScreenHeight = UIScreen.main.bounds.size.height - 86
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    @IBAction func buttonPlayPressed(_ sender: AnyObject) {
        self.delegate?.startViewControllerDidPressPlay(self)
    }
}

protocol StartViewControllerDelegate: class {
    func startViewControllerDidPressPlay(_ controller: StartViewController)
}
