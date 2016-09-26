//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Jeff Lin on 19/09/2016.
//  Copyright © 2016 iPict. All rights reserved.
//

import UIKit
import Messages
import Firebase
import FirebaseStorage

class MessagesViewController: MSMessagesAppViewController {
    
    var ScreenWidth = UIScreen.main.bounds.size.width
    var ScreenHeight = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        if(FIRApp.defaultApp() == nil){
            FIRApp.configure()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        presentViewController(for: conversation, with: presentationStyle)
        
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
 
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
    
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        var answer: String?
        var senderId: String?
        var games: String?
        let opponent = conversation.remoteParticipantIdentifiers[0].uuidString
        var opponentGuesses: String?
        var guesses: String?
        
        let playerId = conversation.localParticipantIdentifier.uuidString
        
        let prefs = UserDefaults.standard
        if prefs.string(forKey: "Player One") == nil {
            prefs.setValue(opponent, forKey: "Player One")
        }

        let currentMessage = conversation.selectedMessage
        let messageURL = currentMessage?.url
        if (messageURL != nil) {
    
            let urlComponents = NSURLComponents(url: messageURL!, resolvingAgainstBaseURL: false)
            let queryItems = urlComponents?.queryItems

            for item in queryItems! {
                if item.name == "Answer" {
                    answer = item.value
                }
                if item.name == "Player" {
                    senderId = item.value
                }
                if item.name == "Games" {
                    games = item.value
                }
                if item.name == "OpponentGuesses" {
                    guesses = item.value
                }
                if item.name == "Guesses" {
                    opponentGuesses = item.value
                }
            }

        }
        
        print("guesses:\(guesses)")
        print("opponent guesses:\(opponentGuesses)")
        
        // Determine the controller to present.
        let controller: UIViewController
        
        if presentationStyle == .compact {
            //show start view
            controller = instantiateStartViewController()
        }
        else {
            print("number of games:\(games)")
            if games == "2" {
                controller = instantiateWinViewController(playerId: playerId, opponent: opponent, guesses: Int(guesses!)!, opponentGuesses: Int(opponentGuesses!)!)
            } else if (conversation.selectedMessage != nil) {
                let prefs = UserDefaults.standard
                if prefs.string(forKey: answer!) == "true" {
                    controller = instantiateSendPicViewController(with: playerId, oldAnswer: answer!, games: Int(games!)!, opponent: opponent, guesses: Int(guesses!)!, opponentGuesses: Int(opponentGuesses!)!)
                } else {
                    if (senderId == playerId) {
                        controller = instantiateGameViewController(with: playerId, answer: answer!, draggable: false, games: Int(games!)!, opponent: opponent, guesses: Int(guesses!)!, opponentGuesses: Int(opponentGuesses!)!)
                    } else {
                        controller = instantiateGameViewController(with: playerId, answer: answer!, draggable: true, games: Int(games!)!, opponent: opponent, guesses: Int(guesses!)!, opponentGuesses: Int(opponentGuesses!)!)
                    }
                }
            } else {
                let oldAnswer = ""
                controller = instantiateSendPicViewController(with: playerId, oldAnswer: oldAnswer, games: 0, opponent: opponent, guesses: 0, opponentGuesses: 0)
            }
        }
        
        // Remove any existing child controllers.
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }

        // Embed the new controller.
        addChildViewController(controller)

        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)

        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        controller.didMove(toParentViewController: self)
    }
    
    func instantiateStartViewController() -> UIViewController {
        // Instantiate a `StartViewController` and present it.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: StartViewController.storyboardIdentifier) as? StartViewController else { fatalError("Unable to instantiate an StartViewController from the storyboard") }
        
        controller.delegate = self
        return controller
    }
    
    func instantiateWinViewController(playerId: String, opponent: String, guesses: Int, opponentGuesses: Int) -> UIViewController {
        // Instantiate a `WinViewController` and present it.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: WinViewController.storyboardIdentifier) as? WinViewController else { fatalError("Unable to instantiate an WinViewController from the storyboard") }
        
        controller.playerId = playerId
        controller.opponent = opponent
        controller.guesses = guesses
        controller.opponentGuesses = opponentGuesses
        controller.delegate = self
        return controller
    }
    
    func instantiateSendPicViewController(with playerId: String, oldAnswer: String, games: Int, opponent: String, guesses: Int, opponentGuesses: Int) -> UIViewController {
        // Instantiate a `SendPicViewController` and present it.
        
        guard let controller = storyboard?.instantiateViewController(withIdentifier: SendPicViewController.storyboardIdentifier) as? SendPicViewController else { fatalError("Unable to instantiate an SendPicViewController from the storyboard") }

        controller.guesses = guesses
        controller.opponentGuesses = opponentGuesses
        controller.opponent = opponent
        controller.games = games
        controller.playerId = playerId
        controller.oldAnswer = oldAnswer
        controller.delegate = self
        return controller
    }
    
    func instantiateGameViewController(with playerId: String, answer: String, draggable: Bool, games: Int, opponent: String, guesses: Int, opponentGuesses: Int) -> UIViewController {
      // Instantiate a `GameViewController` and present it.
        
        guard let controller = storyboard?.instantiateViewController(withIdentifier: GameViewController.storyboardIdentifier) as? GameViewController else { fatalError("Unable to instantiate an GameViewController from the storyboard") }
    
        controller.opponent = opponent
        controller.guesses = guesses
        controller.opponentGuesses = opponentGuesses
        controller.games = games
        controller.playerId = playerId
        controller.draggable = draggable
        controller.answer = answer
        controller.dealRandomTile()
        controller.delegate = self
        return controller
   }
    
    func composeMessage(with board: Board, caption: String, playerId: String, games: Int?, opponent: String, guesses: Int, opponentGuesses: Int, session: MSSession? = nil) -> MSMessage {
        var components = URLComponents()
        let games = games ?? 0
        components.queryItems = [URLQueryItem(name: "Answer", value: board.answer), URLQueryItem(name: "Player", value: playerId), URLQueryItem(name: "Games", value: String(games)), URLQueryItem(name: playerId, value: String(guesses)), URLQueryItem(name: "Guesses", value: String(guesses)), URLQueryItem(name: "OpponentGuesses", value: String(opponentGuesses))]
        
        print("query\(components.queryItems)")
        
        let layout = MSMessageTemplateLayout()
        layout.image = board.image
        
        //set correct player in caption
        let prefs = UserDefaults.standard
        print("pref:\(prefs.string(forKey: "Player One"))")
        if prefs.string(forKey: "Player One") == opponent {
            layout.caption = "Player One sent a picture!"
        } else {
            layout.caption = "Player Two sent a picture!"
        }
        
        
        let message = MSMessage(session: session ?? MSSession())
        message.url = components.url!
        message.layout = layout
        
        return message
    }
    
    func composeWinMessage(with playerId: String, games: Int?, opponent: String, guesses: Int, opponentGuesses: Int, session: MSSession? = nil) -> MSMessage {
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "Player", value: playerId), URLQueryItem(name: "Games", value: String(games!)), URLQueryItem(name: playerId, value: String(guesses)), URLQueryItem(name: "Guesses", value: String(guesses)), URLQueryItem(name: "OpponentGuesses", value: String(opponentGuesses))]
        
        print("query\(components.queryItems)")
        
        let layout = MSMessageTemplateLayout()
        let image = UIImage(named: "msg.png")
        layout.image = image
        
        //set correct player in caption
        layout.caption = "Match Results!"

        let message = MSMessage(session: session ?? MSSession())
        message.url = components.url!
        message.layout = layout
        
        return message
    }
    

    
}

extension MessagesViewController: StartViewControllerDelegate {
    func startViewControllerDidPressPlay(_ controller: StartViewController) {
        // display the SendPicView (sendPicView displays at start expand/play button click and after picture is answered correctly)
        requestPresentationStyle(.expanded)
    }
}

extension MessagesViewController: WinViewControllerDelegate {
    func winViewControllerDidPressRematch(_ controller: WinViewController) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        
        let controller = instantiateSendPicViewController(with: conversation.localParticipantIdentifier.uuidString, oldAnswer: "", games: 0, opponent: conversation.remoteParticipantIdentifiers[0].uuidString, guesses: 0, opponentGuesses: 0)
        
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }

        //Embed the new controller.
        addChildViewController(controller)

        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        controller.didMove(toParentViewController: self)
        
    }
}

extension MessagesViewController: SendPicViewControllerDelegate {
    func sendPicViewController(_ controller:SendPicViewController, didGetBoard board: Board, oldAnswer: String) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        guard let playerId = controller.playerId else { fatalError("Expected the controller to have a player") }

        print("iden:\(conversation.remoteParticipantIdentifiers)")
        
        let message = composeMessage(with: board, caption: NSLocalizedString("", comment: ""), playerId: playerId, games: controller.games, opponent: controller.opponent!, guesses: controller.guesses!, opponentGuesses: controller.opponentGuesses!, session: conversation.selectedMessage?.session)
        
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
        
        let prefs = UserDefaults.standard
        if prefs.string(forKey: controller.oldAnswer!) != nil {
            prefs.removeObject(forKey: controller.oldAnswer!)
        }

        
        dismiss()
    }
}

extension MessagesViewController: GameViewControllerDelegate {
    func presentSendPicViewController(_ controller:GameViewController) {
        guard activeConversation != nil else { fatalError("Expected a conversation") }
        guard let playerId = controller.playerId else { fatalError("Expected the controller to have a player") }
        let oldAnswer = controller.answer
        let games = controller.games
        let opponent = controller.opponent
        let guesses = controller.guesses
        let opponentGuesses = controller.opponentGuesses

        let controller = instantiateSendPicViewController(with: playerId, oldAnswer: oldAnswer!, games: games!, opponent: opponent!, guesses: guesses!, opponentGuesses: opponentGuesses!)
        
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }

        //Embed the new controller.
        addChildViewController(controller)

        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        controller.didMove(toParentViewController: self)
    }
    
    func presentWinViewController(_ controller:GameViewController, playerId: String, opponent: String, guesses: Int, opponentGuesses: Int) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        let playerId = controller.playerId
        let opponent = controller.opponent
        let guesses = controller.guesses
        let opponentGuesses = controller.opponentGuesses
        
        let message = composeWinMessage(with: playerId!, games: controller.games, opponent: opponent!, guesses: guesses!, opponentGuesses: opponentGuesses!, session: conversation.selectedMessage?.session)
        
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
        
        dismiss()
        
    }

}
