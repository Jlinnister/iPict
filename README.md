# iPict
iPict is a mobile multiple game built as an iOS iMessage application using Swift 3.0. (Coming to the iMessage App Store soon!)

screenshots

## Gameplay
Challenge your friends directly in iMessage to a quick and exciting game of iPict. Select one of the four pictures for your friend to guess the word. Challenge yourself to see if you can choose the most difficult! Complete the match with the lowest number of guesses to win.

#### Features:
- [ ] Large set of pictures to keep you entertained for hours
- [ ] Choose the picture you want to challenge your friend with
- [ ] Engaging user interaction with draggable tiles, sound effects and background music
- [ ] Compete with your friends by comparing scores at the end of each match

## Implementation
iPict was developed within two weeks after Apple announced their new iMessage extension framework in iOS 10.

Despite being similar to an iOS app, the iMessage extension framework includes several important differences that we struggled with along the way.

#### The Lifecycle
iMessage extensions interact with users in the conversation through generated messages. This is handled in a new class called the `MSMessagesAppViewController` which acts as the foundational view controller that manages the application. `MSMessagesAppViewController` has typical lifecycle methods along with new methods that track messages in the current conversation. In order to present the correct view to the user, we utilized the `willBecomeActive` and `WillTransition` methods to call a `presentViewController` function, passing in the `conversation` object and current `presentationStyle` that determines which view to render.

```
override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
    // Called before the extension transitions to a new presentation style.
    guard let conversation = activeConversation else { fatalError("Expected an active converstation") }

    presentViewController(for: conversation, with: presentationStyle)
}
```
#### The Views
An iMessage extension lives in the iMessage application. Consequently, an iMessage extension must be compatible in its `compact` view and `expanded` view.
