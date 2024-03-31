//
//  ViewController.swift
//  tiktok_ios
//
//  Created by riko on 2024/03/31.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController, UIScrollViewDelegate {
    var players: [AVPlayer] = []
    
    let scrollView = UIScrollView()
    
    let videoUrls = [
        "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/pexels-bu%CC%88s%CC%A7ra-c%CC%A7akmak-20159065+(1080p).mp4",
        "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/file_example_MP4_1920_18MG.mp4",
        "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/pexels-cristian-rossa-20208157+(Original).mp4",
        "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/Video+MP4_Moon+-+testfile.org.mp4",
        "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/test_30mb.mp4",
        "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/flower.mp4",
        "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/Video+MP4_Moon+-+testfile.org.mp4"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        addVideosToScrollView()
        addButtonsToScrollView()
        
        scrollView.delegate = self
    }
    
    func setupScrollView() {
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * CGFloat(videoUrls.count))
        scrollView.isPagingEnabled = true
        view.addSubview(scrollView)
    }
    
    func addVideosToScrollView() {
        players = [] // プレイヤー配列を初期化

        for (index, videoUrlString) in videoUrls.enumerated() {
            guard let url = URL(string: videoUrlString) else { continue }

            let videoView = UIView(frame: CGRect(x: 0, y: view.frame.height * CGFloat(index), width: view.frame.width, height: view.frame.height))
            scrollView.addSubview(videoView)

            let player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = videoView.bounds
            playerLayer.videoGravity = .resizeAspectFill
            videoView.layer.addSublayer(playerLayer)

            players.append(player) // プレイヤーを配列に追加
        }
    }
    
    func addButtonsToScrollView() {
        // ボタンの追加ロジック（以前の実装をここに移動）
        let buttonHeight: CGFloat = 60
        let buttonWidth: CGFloat = 60
        let gapBetweenButtons: CGFloat = 20
        let pageHeight = view.frame.height
        
        for page in 0..<videoUrls.count {
            let buttonsStartY = pageHeight * CGFloat(page) + (pageHeight / 2 - (buttonHeight * 5 + gapBetweenButtons * 4) / 2) + 100
            
            for i in 0..<5 {
                let button = UIButton(frame: CGRect(x: scrollView.frame.width - buttonWidth - 20,
                                                    y: buttonsStartY + CGFloat(i) * (buttonHeight + gapBetweenButtons),
                                                    width: buttonWidth,
                                                    height: buttonHeight))
                button.backgroundColor = .white
                button.layer.cornerRadius = buttonWidth / 2
                button.setTitle("\(i+1)", for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                scrollView.addSubview(button)
            }
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        print("Button \(sender.title(for: .normal) ?? "") tapped")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.y / scrollView.frame.size.height)
        if pageIndex < players.count {
            let player = players[pageIndex]
            player.play()
        }
    }
}


