//
//  MyListViewController.swift
//  tiktok_ios
//
//  Created by riko on 2024/03/31.
//

import UIKit
import AVFoundation

class MyListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView!

    let headerView = UIView()
    let backButton = UIButton(type: .system)
    let usernameLabel = UILabel()

    let videoUrls: [URL] = [
        URL(string: "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/pexels-bu%CC%88s%CC%A7ra-c%CC%A7akmak-20159065+(1080p).mp4")!,
        URL(string: "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/file_example_MP4_1920_18MG.mp4")!,
        URL(string: "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/pexels-cristian-rossa-20208157+(Original).mp4")!,
        URL(string: "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/Video+MP4_Moon+-+testfile.org.mp4")!,
        URL(string: "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/test_30mb.mp4")!,
        URL(string: "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/flower.mp4")!,
        URL(string: "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/Video+MP4_Moon+-+testfile.org.mp4")!
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // headerViewのフレームをセットアップ
        let topInset = view.safeAreaInsets.top
        headerView.frame = CGRect(x: 0, y: topInset, width: view.bounds.width, height: 90)
        
        // collectionViewのフレームをセットアップ（headerViewの下からスタート）
        let collectionViewY = headerView.frame.maxY
        collectionView.frame = CGRect(x: 0, y: collectionViewY, width: view.bounds.width, height: view.bounds.height - collectionViewY)
    }


    func setupHeaderView() {
        // セーフエリアの上端を考慮して、headerViewのY位置を設定
       let topInset = view.safeAreaInsets.top
       headerView.frame = CGRect(x: 0, y: topInset, width: view.bounds.width, height: 90)
       headerView.backgroundColor = .white
       view.addSubview(headerView)

        // backButtonを画像で設定
       let backImage = UIImage(named: "backIcon") // 'backIcon'はアセットカタログにある画像の名前
       backButton.setImage(backImage, for: .normal)
       backButton.imageView?.contentMode = .scaleAspectFit
       backButton.frame = CGRect(x: 10, y: (headerView.bounds.height - 40) / 2, width: 30, height: 25)
       backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
       headerView.addSubview(backButton)

        usernameLabel.text = "ユーザー名"
        usernameLabel.textAlignment = .center
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        usernameLabel.sizeToFit()
        usernameLabel.frame.origin = CGPoint(x: (headerView.bounds.width - usernameLabel.bounds.width) / 2, y: (headerView.bounds.height - usernameLabel.bounds.height) / 2)
        headerView.addSubview(usernameLabel)
    }


    @objc func backButtonTapped() {
        print("戻るボタンtapped")
        dismiss(animated: true, completion: nil)
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let totalSpacing = spacing * (2 + 1)
        let itemWidth = (view.bounds.width - totalSpacing) / 2
        let itemHeight = itemWidth * 1.5

        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) // フレームはviewDidLayoutSubviewsで設定
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .white
            view.addSubview(collectionView) // ここで追加だけしておきます
       
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }

        let imageView = UIImageView(frame: cell.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        cell.contentView.addSubview(imageView)

        let videoURL = videoUrls[indexPath.row]
        DispatchQueue.global(qos: .background).async {
            let thumbnailImage = self.generateThumbnail(for: videoURL)
            DispatchQueue.main.async {
                imageView.image = thumbnailImage
            }
        }

        return cell
    }

    func generateThumbnail(for url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.maximumSize = CGSize(width: 200, height: 200)
        let time = CMTime(seconds: 1, preferredTimescale: 60)

        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: img)
        } catch {
            print("サムネイル生成エラー: \(error)")
            return nil
        }
    }
}
