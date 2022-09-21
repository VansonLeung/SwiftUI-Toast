//
//  ContentView.swift
//  Shared
//
//  Created by van on 21/9/2022.
//

import SwiftUI
import SwiftUIToast

struct ContentView: View {
    var body: some View {
        ZStack {

            Button {
                SUIToast.show(messageItem: .init(
                    message: "Hello me !  \(Date.now.timeIntervalSinceReferenceDate)",
                    bgColor: .init(red: 0.1, green: 0.5, blue: 0.1),
                    messageColor: .white
                ))
            } label: {
                Text("Click to toast")
            }
            

            SUIToastViewContainer(stackOverlap: .stack)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
