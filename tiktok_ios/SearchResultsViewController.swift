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
        view.backgroundColor = .white
        setupCollectionView()
        setSearchBar()
        layoutViews()
    }
    
    func setSearchBar() {
        headerView.backgroundColor = .white
        view.addSubview(headerView)
        
        // Configure the back button
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.tintColor = .blue
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        headerView.addSubview(backButton)
        
        // Search Container View Configuration
        searchContainerView.backgroundColor = .white
        searchContainerView.layer.cornerRadius = 10
        searchContainerView.layer.borderWidth = 1
        searchContainerView.layer.borderColor = UIColor.lightGray.cgColor
        headerView.addSubview(searchContainerView)
        
        // Search Text View Configuration
        searchTextView.isScrollEnabled = true
        searchTextView.showsHorizontalScrollIndicator = true
        searchTextView.showsVerticalScrollIndicator = false
        searchTextView.alwaysBounceVertical = false
        searchTextView.alwaysBounceHorizontal = true
        searchTextView.contentSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: searchTextView.frame.height)
        searchTextView.textContainer.widthTracksTextView = false
        searchContainerView.addSubview(searchTextView)

        // Search Button Configuration
        searchButton.setTitle("検索", for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchContainerView.addSubview(searchButton)
    }

    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let totalSpacing = spacing * (2 + 1)  // Assuming 2 is the number of columns
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
        view.addSubview(collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        // Remove previous subviews
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
            print("Thumbnail generation error: \(error)")
            return nil
        }
    }

    @objc private func searchButtonTapped() {
        // Intended for search action, currently prints to console for demo purposes
        print("Search button tapped")
    }
    
    private func layoutViews() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchContainerView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            searchContainerView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            searchContainerView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            searchContainerView.heightAnchor.constraint(equalToConstant: 50),
            headerView.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 8)
        ])

        searchTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 8),
            searchTextView.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 8),
            searchTextView.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -8),
            searchTextView.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -8)
        ])

        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -8),
            searchButton.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
