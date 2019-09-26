# CPK
A online-photo viewer app, which fetches photo from Flickr. 

## Getting Started

The app is written purely in Swift 5. It supports iOS 10 or newer, and could run even on iPhone 5 with no lag. 


### Prerequisites

```
MacOS Majave (10.14.6) or newer
Xcode 11 or newer
```

### Deployment

The app does not require any dependencies.
```
 1. Open xcodeproj file by Xcode 11 or later
 2. Search for __ApiKeys.plist__ and replace with your Flickr API's Key.
 3. Press Cmd+R (Product -> Run) to run
```

### Features
1. Home screen displays list of photos
    1. Photos are arranged in a collection view with mosaic layout
    2. Pull to refresh
    3. Smooth scrolling 
2. Detail screen displays full-size photo with its title

### Behind the scene
- The app follows MVVM design pattern
- Protocol-Oriented programming is exploited in removing duplication and boilerplate code
- UI follows Apple guidline
  - UICollectionView uses a new function introduced in WWDC 2016 (iOS 10) for scrolling optimisation
  - Large title (iOS 11)
  - Mosaic layout (iOS photo app)
- Swift Generics is used for buiding core functions such as request-response, API handler

### How would you make it better?
1. Use NSOperations instead it GCD to cancel fetching task if cell goes off screen.
2. Core Data might be considered for offline mode

### Author
__Nhan Truong (Kyle)__ - Initial work
