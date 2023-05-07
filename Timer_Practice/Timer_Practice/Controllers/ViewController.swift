//
//  ViewController.swift
//  Timer_Practice
//
//  Created by 박진형 on 2023/05/03.
//

import UIKit

class ViewController: UIViewController {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    let timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        return datePicker
    }()
    
    lazy var startBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("타이머 시작", for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(onStartBtnTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayOut()
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        view.backgroundColor = .white
        view.addSubview(stackView)
        stackView.addArrangedSubview(timePicker)
        stackView.addArrangedSubview(startBtn)
        
    }
    
    func setAutoLayOut(){
        let guide = view.safeAreaLayoutGuide
        let margin: CGFloat = 20
        
        stackView.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
        
        timePicker.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        timePicker.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: margin).isActive = true
        timePicker.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -margin).isActive = true
        
        startBtn.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: margin).isActive = true
        startBtn.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: margin).isActive = true
        startBtn.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -margin).isActive = true
    }
    
    @objc func onStartBtnTapped(){
        let countDownVC = CountDownViewController()
        // MARK: FullScreen으로 모달 띄우기
        countDownVC.modalPresentationStyle = .fullScreen
        countDownVC.remainingTime = timePicker.countDownDuration
        present(countDownVC, animated: true)
    }
}

