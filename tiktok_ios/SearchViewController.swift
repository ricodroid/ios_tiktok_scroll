import UIKit

class SearchViewController: UIViewController {
    
    let searchContainerView = UIView()
    let searchTextField = UITextField()
    let searchButton = UIButton(type: .system)
    let tagsStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        layoutViews()
    }
    
    private func setupViews() {
        // Search Container View Configuration
        searchContainerView.backgroundColor = .white
        searchContainerView.layer.cornerRadius = 10
        searchContainerView.layer.borderWidth = 1
        searchContainerView.layer.borderColor = UIColor.lightGray.cgColor
        
        // Search Text Field Configuration
        searchTextField.borderStyle = .none
        searchTextField.placeholder = "Search"
        
        // Search Button Configuration
        searchButton.setTitle("検索", for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        // Tags Stack View Configuration
        tagsStackView.axis = .horizontal
        tagsStackView.alignment = .center
        tagsStackView.distribution = .fillProportionally
        tagsStackView.spacing = 8
        
        // Add tags to the stack view with an action
        let tags = ["食事療法", "筋力トレーニング", "気象病", "FCS カウンセリング", "運動療法"]
        for tag in tags {
            let tagButton = UIButton(type: .system)
            tagButton.setTitle(tag, for: .normal)
            tagButton.backgroundColor = UIColor.systemBlue
            tagButton.setTitleColor(.white, for: .normal)
            tagButton.layer.cornerRadius = 14
            tagButton.clipsToBounds = true
            tagButton.addTarget(self, action: #selector(tagButtonTapped(_:)), for: .touchUpInside)
            tagsStackView.addArrangedSubview(tagButton)
            tagButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        }
        
        // Add subviews to search container
        searchContainerView.addSubview(searchTextField)
        searchContainerView.addSubview(searchButton)
        
        // Add subviews to view
        view.addSubview(searchContainerView)
        view.addSubview(tagsStackView)
    }
    
    private func layoutViews() {
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        tagsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for the search container view
        NSLayoutConstraint.activate([
            searchContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchContainerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Constraints for the search text field
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 8),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -8)
        ])
        
        // Constraints for the search button
        NSLayoutConstraint.activate([
            searchButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -8),
            searchButton.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        // Constraints for the tags stack view
        NSLayoutConstraint.activate([
            tagsStackView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 20),
            tagsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tagsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func searchButtonTapped() {
        // Perform the search action
    }
    
    @objc private func tagButtonTapped(_ sender: UIButton) {
        // Append the tag's title to the search text field with hashtag format
        if let tagTitle = sender.titleLabel?.text {
            // Check if the text field already contains text
            if let searchText = searchTextField.text, !searchText.isEmpty {
                // Add a space if there is already text in the search box
                searchTextField.text = "\(searchText) \(tagTitle)"
            } else {
                // Otherwise, start with the first tag
                searchTextField.text = "\(tagTitle)"
            }
        }
    }
}

