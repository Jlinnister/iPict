# iPict
iPict is a mobile multiple game built as an iOS iMessage application using Swift 3.0. 

<img src="https://github.com/Jlinnister/iPict/blob/master/screenshots/start.png?raw=true" width=250 ><img src="https://github.com/Jlinnister/iPict/blob/master/screenshots/new.png?raw=true" width=250 ><img src="https://github.com/Jlinnister/iPict/blob/master/screenshots/message.png?raw=true" width=250 >
<br><br>
<img src="https://github.com/Jlinnister/iPict/blob/master/screenshots/turn.png?raw=true" width=250 ><img src="https://github.com/Jlinnister/iPict/blob/master/screenshots/goodjob.png?raw=true" width=250 ><img src="https://github.com/Jlinnister/iPict/blob/master/screenshots/win.png?raw=true" width=250 >

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
An iMessage extension lives in the iMessage application. Consequently, an iMessage extension must be compatible in its `compact` view and `expanded` view. We quickly moved away from Xcode's Interface Builder as it does not distinguish between the two for an iMessage extension. Instead, we began checking the current type of view using `MSMessagesAppPresentationStyle` and calling the appropriate function to instantiate the correct view using the `storyboard.instantiateViewController` method and passing in the view's identifier.

```
func instantiateStartViewController() -> UIViewController {
    // Instantiate a `StartViewController` and present it.
    guard let controller = storyboard?.instantiateViewController(withIdentifier: StartViewController.storyboardIdentifier) as? StartViewController else { fatalError("Unable to instantiate an StartViewController from the storyboard") }

    controller.delegate = self
    return controller
}
```

#### Responsive Design
In addition to presenting the correct view, we programmatically calculated rendering based on the screen's width and height. This enabled us to handle rendering correctly for all iOS devices. In the example below, we use this method to correctly display tiles.

```
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
```

## Technologies
iPict utilizes new Swift 3.0 syntax. Additional technology that iPict employs includes `Firebase` for image storage and retrieval and `AVFoundation` for audio.

#### Firebase
In order to properly connect to Firebase, `Firebase` and `FirebaseStorage` was imported in the`MessagesViewController` and configured in the `viewDidLoad` lifecycle method. Because an iMessage app is an extension and is not considered a standalone application, we realized we did not have access to `AppDelegate` on the application's initialization as standalone iOS apps do. As a workaround, we implemented the below code.

```
override func viewDidLoad() {
    // Do any additional setup after loading the view.
    super.viewDidLoad()
    if(FIRApp.defaultApp() == nil){
        FIRApp.configure()
    }
}
```

Images are retrieved from Firebase Storage via references to its filename. Each picture's answer is conveniently stored as the filename to enable fast lookup and retrieval.

```
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
```

#### AVFoundation
Background music and tile sounds are included by using the `AVFoundation` class. The `AVAudioPlayer` object was used to handle the sound files.

```
func playBGM() {
    if let bgm = bgm {
        if bgm.isPlaying {
            bgm.currentTime = 0
        } else {
            bgm.play()
        }
    }
}
```
