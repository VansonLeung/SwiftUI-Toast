//
//  SwiftUIToast.swift
//  SwiftUIToast
//
//  Created by Vanson Leung on 21/9/2022.
//

import SwiftUI


/**
 SUIToast
 
 Alias of SUIToastController
 
 */
public var SUIToast : SUIToastController {
    return SUIToastController.shared
}



/**
 SUIToastController
 
 Supposedly a singleton to wrap and control all toast items
 
 */
public class SUIToastController : ObservableObject {
    
    public static var shared = SUIToastController()
    
    public var toastLengthLong = 3.5
    
    public var toastLengthShort = 2.0

    @Published var items: [SUIToastViewCellItem] = []
    
    private var updateTimer: Timer?
    
    func initialize() {
        startTimer()
    }
    
    func uninitialize() {
        stopTimer()
    }
    
    public func show(_ message: String) {
        items.append(
            .init(
                message: message
            )
        )
    }
    
    public func show(messageItem: SUIToastViewCellItem) {
        items.append(
            messageItem
        )
    }
    
    func startTimer() {
        updateTimer = .scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(SUIToastController.onUpdate),
            userInfo: nil,
            repeats: true)
    }
    
    func stopTimer() {
        if let updateTimer = updateTimer {
            updateTimer.invalidate()
            self.updateTimer = nil
        }
    }
    
    @objc func onUpdate() {
        var isUpdated = false
        
        for k in (0 ..< items.count).reversed() {
            let it = items[k]
            if it.isExpired {
                items.remove(at: k)
                isUpdated = true
            }
        }
        
        if isUpdated {
            self.objectWillChange.send()
        }
    }
}

public struct SUIToastViewCellItem: Identifiable, Hashable {
    
    public var id: String
    public var message: String
    public var bgColor: Color
    public var messageColor: Color
    public var createdAt: Date
    public var toastLength: CGFloat
    
    public init(
        message: String = "",
        length: CGFloat = SUIToast.toastLengthLong,
        bgColor: Color = .black,
        messageColor: Color = .white
    ) {
        self.id = UUID().uuidString
        self.message = message
        self.bgColor = bgColor
        self.messageColor = messageColor
        self.createdAt = Date.now
        self.toastLength = length
    }

    var isExpired: Bool {
        get {
            return Date.now.timeIntervalSinceReferenceDate - createdAt.timeIntervalSinceReferenceDate > toastLength
        }
    }
}




public struct SUIToastViewContainer: View {
    
    @StateObject var toastObs = SUIToastController.shared
    
    public enum StackAlignment {
        case top
        case bottom
        case middle
    }
    
    public enum StackOverlap {
        case overlap
        case stack
    }
    
    var stackAlignment: StackAlignment = .bottom
    var stackOverlap: StackOverlap = .overlap
    
    public init() {
        
    }
    
    
    public init(
        stackAlignment: StackAlignment = .bottom,
        stackOverlap: StackOverlap = .overlap,
        toastObs: StateObject<SUIToastController>? = nil
    ) {
        self.stackAlignment = stackAlignment
        self.stackOverlap = stackOverlap
        
        if let toastObs = toastObs {
            self._toastObs = toastObs
        }
    }
    
    
    
    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if stackAlignment == .bottom
                    || stackAlignment == .middle {
                    Spacer()
                }
                
                if stackOverlap == .overlap {
                    ZStack(alignment: .center) {
                        ForEach(
                            toastObs.items,
                            id: \.id
                        )
                        { it in
                            
                            VStack(spacing: 0) {
                                Spacer()
                                SUIToastViewCell(
                                    item: it
                                )
                                .zIndex(it.createdAt.timeIntervalSinceReferenceDate)
                                .transition(
                                    .opacity.combined(with: .move(edge: .bottom))
                                )
                            }
                            
                            
                        }
                    }

                }
                else if stackOverlap == .stack
                {
                    ForEach(
                        toastObs.items.reversed(),
                        id: \.id
                    )
                    { it in
                        
                        SUIToastViewCell(
                            item: it
                        )
                        .transition(
                            .opacity.combined(with: .move(edge: .bottom))
                        )
                        
                    }

                }
                
                

                if stackAlignment == .top
                    || stackAlignment == .middle {
                    Spacer()
                }
            }
        }
        .animation(.default, value: toastObs.items)
        .onAppear {
            toastObs.initialize()
        }
        .onDisappear {
            toastObs.uninitialize()
        }
    }
}

internal struct SUIToastViewCell: View {
    var item: SUIToastViewCellItem
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Text(item.message)
                        .foregroundColor(item.messageColor)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(item.bgColor)
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .allowsHitTesting(false)
    }
}




