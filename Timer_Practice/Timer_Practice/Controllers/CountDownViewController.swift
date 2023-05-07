//
//  CountDownViewController.swift
//  Timer_Practice
//
//  Created by 박진형 on 2023/05/03.
//

/*
 고민 1. 타이머를 어떻게 화면 넘기자마자 시작시킬까?
 1-1. viewDidLoad()에서 startTimer() 하면 되긴 되는데 일시정지가 안먹힌다..;
 */

import UIKit

class CountDownViewController: UIViewController {
    
    var filteredList: [Record] = []
    var remainingTime: TimeInterval = 0.0
    var originTime: TimeInterval = 0.0
    
    var imminentLabel: UILabel = {
        let label = UILabel()
        label.text = "시간이 임박했어요!"
        label.textColor = .red
        label.alpha = 0.5
        label.font = .systemFont(ofSize: 17, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00 : 00 : 00"
        label.font = .systemFont(ofSize: 42, weight: .heavy)
        return label
    }()
    
    lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .tintColor
        progressView.trackTintColor = .gray
        progressView.progressViewStyle = .bar
        progressView.setProgress(1 , animated: true)
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 5
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 5// 뒤에 있는 회색 track
        progressView.subviews[1].clipsToBounds = true
        return progressView
    }()
    
    lazy var pauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("일시정지", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.addTarget(self, action: #selector(onPauseButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return button
    }()
    
    var isPaused: Bool = false
    
    lazy var recordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitle("기록", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.addTarget(self, action: #selector(onRecordButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.addTarget(self, action: #selector(onCancelButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return button
    }()
    
    let buttonView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var timer: Timer?
    
    var recordTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordTableView.delegate = self
        recordTableView.dataSource = self
        
        self.recordTableView.register(RecordTableViewCell.self, forCellReuseIdentifier: "RecordTableViewCell")
        
        setUI()
        setAutoLayOut()
        setTimeLabel()
        makeTestData()
    }
    
    func makeTestData() {
        filteredList.append(Record(time: "00 : 00 : 00", percent: "( 0.1% 경과 )", memo: "추가 메모 없음"))
    }
    
    func setUI(){
        view.backgroundColor = .white
        
        view.addSubview(imminentLabel)
        view.addSubview(timeLabel)
        view.addSubview(progressBar)
        view.addSubview(buttonView)
        
        buttonView.addArrangedSubview(pauseButton)
        buttonView.addArrangedSubview(recordButton)
        buttonView.addArrangedSubview(cancelButton)
        
        view.addSubview(recordTableView)
    }
    
    func setAutoLayOut(){
        let guide = view.safeAreaLayoutGuide
        let horizontalMargin: CGFloat = 20
        let verticalMargin: CGFloat = 40
        
        // 시간이 임박했어요!
        imminentLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 80).isActive = true
        imminentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // 00:00:00
        timeLabel.topAnchor.constraint(equalTo: imminentLabel.bottomAnchor, constant: verticalMargin).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // ProgressBar
        progressBar.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: verticalMargin).isActive = true
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: horizontalMargin).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: guide.leadingAnchor, constant: -horizontalMargin).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        // 3 Button
        buttonView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: verticalMargin).isActive = true
        buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        // Table View
        recordTableView.topAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: verticalMargin).isActive = true
        recordTableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        recordTableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        recordTableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        
    }
    
    func setTimeLabel() {
        let minutes = Int(remainingTime / 60)
        let seconds = Int(remainingTime.truncatingRemainder(dividingBy: 60))
        let milliseconds = Int((remainingTime * 100).truncatingRemainder(dividingBy: 100))
        timeLabel.text = String(format: "%02d : %02d : %02d", minutes, seconds, milliseconds)
    }
    
    @objc func onPauseButtonTapped() {
        if isPaused {
            stopTimer()
            pauseButton.setTitle("다시시작", for: .normal)
            pauseButton.backgroundColor = .systemGreen
            isPaused = false
        } else {
            startTimer()
            pauseButton.setTitle("일시정지", for: .normal)
            pauseButton.backgroundColor = .lightGray
            isPaused = true
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    @objc func updateTime() {
        remainingTime -= 0.01
        
        if remainingTime <= 0 {
            timeLabel.text = "00 : 00 : 00"
            stopTimer()
        } else if remainingTime <= 10 {
            imminentLabel.alpha = 1.0
            timeLabel.textColor = .red
            progressBar.tintColor = .red
            setTimeLabel()
        } else {
            setTimeLabel()
        }
    }
    
    @objc func onRecordButtonTapped() {
        filteredList.append(Record(time: timeLabel.text ?? "",
                                   percent: String((Double(remainingTime) / Double(originTime)) * 100.0) + "%",
                                   memo: "추가 메모 없음"))
        recordTableView.reloadData()
    }
    
    @objc func onCancelButtonTapped() {
        dismiss(animated: true)
    }
}

extension CountDownViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as? RecordTableViewCell else { return UITableViewCell() }
        
        let record = filteredList[indexPath.row]
        cell.timeLabel.text = record.time
        cell.passPercentLabel.text = record.percent
        cell.memoLabel.text = record.memo
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // 원하는 높이 값으로 대체
    }
}
