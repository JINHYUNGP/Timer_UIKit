//
//  CountDownViewController.swift
//  Timer_Practice
//
//  Created by 박진형 on 2023/05/03.
//

import UIKit

class CountDownViewController: UIViewController {
    
    var selectedTime: Date?
    var countDownTime: Int = 0
    let dateFormatter: DateFormatter = {
      let df = DateFormatter()
      df.dateFormat = "HH:mm:ss"
      df.locale = Locale(identifier: "ko_KR")
      df.timeZone = TimeZone.autoupdatingCurrent
      return df
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = dateFormatter.string(from: selectedTime ?? Date())
        label.font = .systemFont(ofSize: 50, weight: .bold)
        label.textColor = selectedTime.- countDownTime =< 10 ? .black : .red
        return label
    }()
    
    lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .tintColor
        progressView.trackTintColor = .gray
        progressView.progressViewStyle = .bar
        progressView.setProgress(1 , animated: true)
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 5)
        return progressView
    }()
    
//    var Button: UIButton = {
//            let button = UIButton()
//            button.backgroundColor =
//            button.setTitle("", for: .normal)
//            button.addTarget(self, action: #selector(), for: .touchUpInside)
//            button.translatesAutoresizingMaskIntoConstraints = false
//            return button
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayOut()
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        view.backgroundColor = .white
        view.addSubview(timeLabel)
        view.addSubview(progressBar)
    }
    
    func setAutoLayOut(){
        let guide = view.safeAreaLayoutGuide
        let verticalMargin: CGFloat = 50
        let horizontalMargin: CGFloat = 20
        let margin: CGFloat = 10
        
        timeLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: verticalMargin).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        
        progressBar.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: margin).isActive = true
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: horizontalMargin).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: guide.leadingAnchor, constant: -horizontalMargin).isActive = true
    
        

        
        
        
        
    }
    
    
    @objc func onButtonTapped(){
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
