//
//  SearchResultsViewController.swift
//  tiktok_ios
//
//  Created by riko on 2024/04/07.
//

import UIKit
import AVFoundation

class SearchResultsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!

    let headerView = UIView()
    let backButton = UIButton(type: .system)
    let usernameLabel = UILabel()
    
    let searchContainerView = UIView()
    let searchTextView = UITextView()
    let searchButton = UIButton(type: .system)

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
        setupCollectionView()
        setSearchBar()
        setSearchBar()
        layoutViews()
        view.backgroundColor = .white
    }
    
    func setSearchBar() {
        // Search Container View Configuration
        searchContainerView.backgroundColor = .white
        searchContainerView.layer.cornerRadius = 10
        searchContainerView.layer.borderWidth = 1
        searchContainerView.layer.borderColor = UIColor.lightGray.cgColor
        
        // Search Text View Configuration
        searchTextView.isScrollEnabled = true
        searchTextView.showsHorizontalScrollIndicator = true
        searchTextView.showsVerticalScrollIndicator = false
        searchTextView.alwaysBounceVertical = false
        searchTextView.alwaysBounceHorizontal = true
        searchTextView.contentSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: searchTextView.frame.height)
        searchTextView.textContainer.widthTracksTextView = false

        // Search Button Configuration
        searchButton.setTitle("検索", for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }



    @objc func backButtonTapped() {
        print("戻るボタンtapped")
        dismiss(animated: true, completion: nil)
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let totalSpacing = spacing * (2 + 1) // Assuming 2 is the number of columns
        let itemWidth = (view.bounds.width - totalSpacing) / 2
        let itemHeight = itemWidth * 1.5

        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
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
    @objc private func searchButtonTapped() {
        // Perform the search action
        print("検索ボタン")
        let searchResultsVC = SearchResultsViewController()
        // myListVC.modalPresentationStyle = .fullScreen // iOS 13以降では、モーダルの全画面表示を指定する場合。
        searchResultsVC.modalPresentationStyle = .fullScreen
        present(searchResultsVC, animated: true, completion: nil)
    }
    
    private func layoutViews() {
        // Add views as subviews before setting up constraints
        view.addSubview(searchContainerView)
            searchContainerView.addSubview(searchTextView)
            searchContainerView.addSubview(searchButton)
        
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        searchTextView.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false

        // Constraints for the search container view
        NSLayoutConstraint.activate([
            searchContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchContainerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Constraints for the search text view
        NSLayoutConstraint.activate([
            searchTextView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 8),
            searchTextView.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 8),
            searchTextView.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -8),
            searchTextView.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -8)
        ])
        
        // Constraints for the search button
        NSLayoutConstraint.activate([
            searchButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -8),
            searchButton.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        // Constraints for collectionView to start below the searchContainerView
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 10),
                collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
                collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

   }
