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
    var expandableTextViews: [ExpandableTextView] = []
    
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
    
    let textContents = [
        "これは最初のビデオの説明です。",
        "ここに2番目のビデオの説明を入れます。",
        "3番目のビデオについての情報がここに来ます。雨にも負けず風邪にも負けず",
        "4番目のビデオについての情報がここに来ます。雨にも負けず風邪にも負けず",
        "5番目のビデオについての情報がここに来ます。雨にも負けず風邪にも負けず",
        
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        addVideosToScrollView()
        addButtonsToScrollView()
        addTextViewsToScrollView()
    }
    
    func setupScrollView() {
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * CGFloat(videoUrls.count))
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)
    }
    
    
    func addVideosToScrollView() {
        for (index, videoUrlString) in videoUrls.enumerated() {
            let url = URL(string: videoUrlString)!
            let videoView = UIView(frame: CGRect(x: 0, y: view.frame.height * CGFloat(index), width: view.frame.width, height: view.frame.height))
            scrollView.addSubview(videoView)
            
            let player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = videoView.bounds
            playerLayer.videoGravity = .resizeAspectFill
            videoView.layer.addSublayer(playerLayer)
            players.append(player)
        }
    }
    
    
    func addButtonsToScrollView() {
        let buttonHeight: CGFloat = 60
        let buttonWidth: CGFloat = 60
        let gapBetweenButtons: CGFloat = 20
        let pageHeight = view.frame.height
        
        let iconNames = ["icon_human", "icon_star", "icon_good", "icon_bad", "icon_search"]
        
        for page in 0..<videoUrls.count {
            let buttonsStartY = pageHeight * CGFloat(page) + (pageHeight / 2 - (buttonHeight * 5 + gapBetweenButtons * 4) / 2) + 100
            
            for i in 0..<iconNames.count {
                let button = UIButton(frame: CGRect(x: scrollView.frame.width - buttonWidth - 20,
                                                    y: buttonsStartY + CGFloat(i) * (buttonHeight + gapBetweenButtons),
                                                    width: buttonWidth,
                                                    height: buttonHeight))
                if let buttonImage = UIImage(named: iconNames[i]) {
                    button.setImage(buttonImage, for: .normal)
                }
                
                button.tag = i // タグの割り当て
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                scrollView.addSubview(button)
            }
        }
    }
    
    
    // タップされた際に切り替える画像の名前を管理する辞書
    let tappedImageNames: [String: String] = [
        "icon_star": "icon_star_tapped",
        "icon_good": "icon_good_tapped",
        "icon_bad": "icon_bad_tapped"
    ]
    
    
    @objc func buttonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected // 選択状態を切り替え
        
        // 初期アイコンとタップされたアイコンの名前を定義
        let initialIconNames = ["icon_human", "icon_star", "icon_good", "icon_bad", "icon_search"]
        let tappedIconNames: [String: String] = [
            "icon_star": "icon_star_tapped",
            "icon_good": "icon_good_tapped",
            "icon_bad": "icon_bad_tapped"
        ]
        
        let currentIconName = initialIconNames[sender.tag]
        var newImageName: String?
        
        if sender.isSelected, let tappedIconName = tappedIconNames[currentIconName] {
            // 選択状態の場合、タップされたアイコンに切り替え
            newImageName = tappedIconName
        } else {
            // 非選択状態の場合、初期アイコンに戻す
            newImageName = currentIconName
        }
        
        if let newImageName = newImageName, let newImage = UIImage(named: newImageName) {
            sender.setImage(newImage, for: .normal)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.y / scrollView.frame.size.height)
        if pageIndex < players.count {
            let player = players[pageIndex]
            player.play()
        }
    }
    
    func addTextViewsToScrollView() {
        let textViewHeight: CGFloat = 100
        let textViewBottomOffset: CGFloat = 10 // 下からのオフセットを10dpに設定
        
        for (index, textContent) in textContents.enumerated() {
            let textViewYPosition = scrollView.frame.height * CGFloat(index) + scrollView.frame.height - textViewHeight - textViewBottomOffset
            let textViewFrame = CGRect(x: 0, y: textViewYPosition, width: scrollView.frame.width, height: textViewHeight)
            let expandableTextView = ExpandableTextView(frame: textViewFrame, text: textContent)
            expandableTextView.tag = index // タグを設定して、どのテキストコンテンツに対応しているか識別
            
            scrollView.addSubview(expandableTextView)
        }
        
        // スクロールビューの contentSize を更新
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height * CGFloat(textContents.count))
    }
    
    
    
    
    
    
}
