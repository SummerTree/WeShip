//
//  ProgressRect.swift
//  CFStories
//
//  Created by Farhan Farooqui on 7/21/20.
//

import SwiftUI
import Combine

class StoryTimer: ObservableObject {
    
    @Published var progress: Double
    private var interval: TimeInterval
    private var maxItems: Int
    private let publisher: Timer.TimerPublisher
    private var cancellable: Cancellable?
    
    
    init(items: Int = 1, interval: TimeInterval) {
        self.maxItems = items
        self.progress = 0
        self.interval = interval
        self.publisher = Timer.publish(every: 0.1, on: .main, in: .default)
    }
    
    func start() {
        self.cancellable = self.publisher.autoconnect().sink(receiveValue: {  _ in
            var newProgress = self.progress + (0.1 / self.interval)
            if Int(newProgress) >= self.maxItems { newProgress = 0 }
            self.progress = newProgress
        })
    }
    
    func advance(by number: Int) {
        let newProgress = max((Int(self.progress) + number) % self.maxItems , 0)
        self.progress = Double(newProgress)
    }
}

struct ProgressRect: View {
    
    @Binding var progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .cornerRadius(5)

                Rectangle()
                    .frame(width: geometry.size.width * CGFloat(self.progress), height: nil, alignment: .leading)
                    .foregroundColor(Color.white.opacity(0.9))
                    .cornerRadius(5)
            }
        }
    }
}
