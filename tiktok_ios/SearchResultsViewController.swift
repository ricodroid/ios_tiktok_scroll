//
//  SearchResultsViewController.swift
//  tiktok_ios
//
//  Created by riko on 2024/04/07.
//

import UIKit
import AVFoundation

class SearchResultsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var videoUrls: [URL] = [
        URL(string: "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/pexels-bu%CC%88s%CC%A7ra-c%CC%A7akmak-20159065+(1080p).mp4")!,
        URL(string: "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/file_example_MP4_1920_18MG.mp4")!,
        URL(string: "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/pexels-cristian-rossa-20208157+(Original).mp4")!,
        URL(string: "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/Video+MP4_Moon+-+testfile.org.mp4")!,
        URL(string: "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/test_30mb.mp4")!,
        URL(string: "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/flower.mp4")!,
        URL(string: "https://test-pvg-video-contents-bucket.s3.ap-northeast-1.amazonaws.com/Video+MP4_Moon+-+testfile.org.mp4")!
    ]
    var thumbnails: [UIImage] = []
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadThumbnails()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: "ThumbnailCell")
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func loadThumbnails() {
        for url in videoUrls {
            let asset = AVAsset(url: url)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time = CMTimeMake(value: 1, timescale: 2)
            let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            if let img = img {
                let thumbnail = UIImage(cgImage: img)
                thumbnails.append(thumbnail)
            }
        }
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! ThumbnailCollectionViewCell
        cell.imageView.image = thumbnails[indexPath.row]
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 10 // Adjust the number of items per row and spacing
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

class ThumbnailCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
