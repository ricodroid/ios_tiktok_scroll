//
//  ExpandableTextView.swift
//  tiktok_ios
//
//  Created by riko on 2024/03/31.
//
// ExpandableTextView.swift
import UIKit

class ExpandableTextView: UIView {
    let textView: UITextView
    let expandButton: UIButton
    var isCollapsed: Bool = true
    var fullText: String
    
    init(frame: CGRect, text: String) {
        textView = UITextView(frame: .zero) // Auto Layoutを使用するため、frameは.zeroで初期化
        expandButton = UIButton(type: .system)
        fullText = text // 全文をプロパティに保存
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // TextViewのスタイル設定
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont.boldSystemFont(ofSize: 16) // Boldのフォントに設定
        textView.textColor = .white // テキストの色を白に設定
        addSubview(textView)
        
        expandButton.addTarget(self, action: #selector(toggleText), for: .touchUpInside)
        
        // Auto Layoutを使用して制約を設定
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10), // 下から10ポイント上に調整
            textView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        // ボタンの設定
        addSubview(expandButton)
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            expandButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
        // 初期テキスト更新処理
        updateText()
    }
    
    @objc private func toggleText() {
            isCollapsed.toggle() // 状態を切り替え
            updateText()
            // ボタンのタイトルを切り替え
            expandButton.setTitle(isCollapsed ? "もっと見る" : "閉じる", for: .normal)
        }
    
    func updateText() {
        if self.isCollapsed {
            let trimmedText = self.fullText.count > 15 ? String(self.fullText.prefix(15)) + "..." : self.fullText
            self.textView.text = trimmedText
            self.expandButton.setTitle("もっと見る", for: .normal)
        } else {
            self.textView.text = self.fullText
            self.expandButton.setTitle("閉じる", for: .normal)
        }
    }
}
