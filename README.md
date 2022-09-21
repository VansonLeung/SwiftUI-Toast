# SwiftUIToast

### Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler. It is in early development, but SwiftUITrackableScrollView does support its use on supported platforms.

Once you have your Swift package set up, adding SwiftUITrackableScrollView as a dependency is as easy as adding it to the dependencies value of your Package.swift.
```swift
dependencies: [
    .package(url: "https://github.com/VansonLeung/SwiftUI-Toast.git")
]
```

### Usage
```swift

import SwiftUIToast

struct ContentView: View {
    var body: some View {
        
        ZStack {
        
        
            // an example button to trigger Toast singleton popup
            
            Button {
                SUIToast.show(messageItem: .init(
                    message: "Hello me !  \(Date.now.timeIntervalSinceReferenceDate)",
                    bgColor: .init(red: 0.1, green: 0.5, blue: 0.1),
                    messageColor: .white
                ))
            } label: {
                Text("Click to toast")
            }
            
            
            
            // singleton container to manage all toasts 
            
            SUIToastViewContainer(stackOverlap: .stack)
            
        
        }
    

    }
}

```
