//
//  CountDownViewController.swift
//  Timer_Practice
//
//  Created by 박진형 on 2023/05/03.
//

/*
 고민 1. 타이머를 어떻게 화면 넘기자마자 시작시킬까?
 1-1. viewDidLoad()에서 startTimer() 하면 되긴 되는데 일시정지가 안먹힌다..;
 
 고민 2. Cell이 겹쳐서 border가 두껍게 보인다..
 */

// TODO: cell을 눌러 메모를 남길 수 있다.
// TODO: 00:00:00가 되면 '타이머가 종료되었어요!'라는 Alert가 뜬다.

import UIKit

class CountDownViewController: UIViewController {
    
//    var filteredList: [Record] = []
    var remainingTime: TimeInterval = 0.0
    var originTime: TimeInterval = 0.0
    
    var imminentLabel: UILabel = {
        let label = UILabel()
        label.text = "시간이 임박했어요!"
        label.textColor = .red
        label.alpha = 0.0
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
        progressView.setProgress(1.0 , animated: true)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recordTableView.reloadData()
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
    
    func setProgressBar() {
        progressBar.progress = Float(remainingTime / originTime)
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
        
        setTimeLabel()
        setProgressBar()
        
        if remainingTime <= 0 {
            let finishAlert = UIAlertController(title: "타이머가 종료되었어요!", message: "", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "종료", style: .cancel)
            finishAlert.addAction(cancelAction)
            present(finishAlert, animated: true, completion: nil)
            stopTimer()
        } else if remainingTime <= 10 {
            imminentLabel.alpha = 1.0
            timeLabel.textColor = .red
            progressBar.tintColor = .red
        }
    }
    
    @objc func onRecordButtonTapped() {
        MyDB.dataList.append(Record(time: timeLabel.text ?? "",
                                   percent: String(format: "%.1f%% 경과",
                                                   100.0 - (Double(remainingTime) / Double(originTime)) * 100.0),
                                   memo: "추가 메모 없음"))
        // 셀이 위로 쌓이게끔 계속 정렬해준다.
        // (이 방법 말고도 스크롤을 위로 올려주는 방법이 있는데, 이게 더 간편함)
        MyDB.dataList.sort(by: { $0.time < $1.time })
        recordTableView.reloadData()
    }
    
    @objc func onCancelButtonTapped() {
        dismiss(animated: true)
    }
}

extension CountDownViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyDB.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as? RecordTableViewCell else { return UITableViewCell() }
        
        let record = MyDB.dataList[indexPath.row]
        cell.timeLabel.text = record.time
        cell.passPercentLabel.text = record.percent
        cell.memoLabel.text = record.memo
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // 원하는 높이 값으로 대체
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addVC = AddViewController()
        let record = MyDB.dataList[indexPath.row]
        
        addVC.modalPresentationStyle = .fullScreen
        addVC.timeLabel.text = record.time
        addVC.passPercentLabel.text = record.percent
        addVC.index = indexPath.row
        
        present(addVC, animated: true)
        // 선택된 셀 해제
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
