//
//  AddViewController.swift
//  Timer_Practice
//
//  Created by 이주희 on 2023/05/07.
//

import UIKit

class AddViewController: UIViewController {
    
    var titleView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.green, for: .normal)
        button.addTarget(self, action: #selector(isCloseButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "메모 추가하기"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.green, for: .normal)
        button.addTarget(self, action: #selector(isSaveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var passPercentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var memoField: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 20
        // border과 너무 맞닿아 있을 때 추가해주기
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var textNumLabel: UILabel = {
        let label = UILabel()
        label.text = "0/50 자"
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraint()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(titleView)
        titleView.addSubview(closeButton)
        titleView.addSubview(titleLabel)
        titleView.addSubview(saveButton)
        view.addSubview(timeLabel)
        view.addSubview(passPercentLabel)
        view.addSubview(memoField)
        view.addSubview(textNumLabel)
    }
    
    private func setConstraint() {
        let guide = view.safeAreaLayoutGuide
        let horizontalMargin: CGFloat = 20
        
        titleView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        titleView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        closeButton.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: horizontalMargin).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        saveButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -horizontalMargin).isActive = true
        saveButton.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 50).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: horizontalMargin).isActive = true
        
        passPercentLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10).isActive = true
        passPercentLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: horizontalMargin).isActive = true
        
        memoField.topAnchor.constraint(equalTo: passPercentLabel.bottomAnchor, constant: 100).isActive = true
        memoField.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: horizontalMargin).isActive = true
        memoField.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -horizontalMargin).isActive = true
        memoField.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        textNumLabel.topAnchor.constraint(equalTo: memoField.bottomAnchor, constant: 10).isActive = true
        textNumLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -horizontalMargin).isActive = true
    }
    
    @objc func isCloseButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func isSaveButtonTapped() {
        
    }

}
