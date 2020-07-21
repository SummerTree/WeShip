//
//  BackgroundView.swift
//  CFStories
//
//  Created by Farhan Farooqui on 7/21/20.
//

import UIKit
import AVFoundation

import SwiftUI
import AVKit
import AVFoundation

struct WelcomeVideo: View {
    
    let url: URL
    
    var body: some View {
        WelcomeVideoController(url: url)
    }
}

struct WelcomeVideo_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeVideo(url: URL(string: "https://videodelivery.net/f95ba4be888ee03831f4743617c94dd5/manifest/video.m3u8?clientBandwidthHint=1.8")!)
    }
}

final class WelcomeVideoController : UIViewControllerRepresentable {
    var playerLooper: AVPlayerLooper?
    var url: URL?
    
    init(url: URL) {
        self.url = url
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<WelcomeVideoController>) ->
        AVPlayerViewController {
            let controller = AVPlayerViewController()

            let asset = AVURLAsset(url: url!)
            let playerItem = AVPlayerItem(asset: asset)
            let queuePlayer = AVQueuePlayer()
            // OR let queuePlayer = AVQueuePlayer(items: [playerItem]) to pass in items
            playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
            queuePlayer.play()
            controller.player = queuePlayer
            

            return controller
        }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<WelcomeVideoController>) {
    }
}
