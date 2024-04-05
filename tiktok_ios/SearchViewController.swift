//
//  SearchViewController.swift
//  tiktok_ios
//
//  Created by r_murata on 2024/04/05.
//

import UIKit

class SearchViewController: UIViewController {

    let searchBar = UISearchBar()
    let scrollView = UIScrollView()
    let tagsStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupBackButton()
        setupSearchBar()
        setupScrollView()
        setupTags()
    }
    
    private func setupBackButton() {
        // ナビゲーションバーの左側に戻るボタンを追加
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backIcon"), style: .plain, target: self, action: #selector(backButtonTapped))
    }

    @objc func backButtonTapped() {
        // このビューコントローラをポップするか、適切なアクションをここに記述
        self.navigationController?.popViewController(animated: true)
    }

    private func setupSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            scrollView.heightAnchor.constraint(equalToConstant: 40) // 適切な高さを設定
        ])
    }

    private func setupTags() {
        tagsStackView.axis = .horizontal
        tagsStackView.spacing = 10
        tagsStackView.alignment = .center
        tagsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(tagsStackView)
        
        NSLayoutConstraint.activate([
            tagsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            tagsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            tagsStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            tagsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        let tags = ["食事関連", "筋力トレーニング", "気分転換", "FCS カウントシリーズ", "運動療法"]
        for tag in tags {
            let tagButton = UIButton()
            tagButton.setTitle("#\(tag)", for: .normal)
            tagButton.backgroundColor = .systemBlue
            tagButton.setTitleColor(.white, for: .normal)
            tagButton.layer.cornerRadius = 5
            tagButton.clipsToBounds = true
            tagButton.addTarget(self, action: #selector(tagTapped(_:)), for: .touchUpInside)
            tagsStackView.addArrangedSubview(tagButton)
        }
        
        tagsStackView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: tagsStackView.frame.width, height: 40)
    }

    @objc func tagTapped(_ sender: UIButton) {
        guard let tagTitle = sender.titleLabel?.text else { return }
        searchBar.text = (searchBar.text ?? "") + " " + tagTitle
    }
}
