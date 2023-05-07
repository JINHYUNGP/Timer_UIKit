//
//  RecordTableViewCell.swift
//  Timer_Practice
//
//  Created by 이주희 on 2023/05/07.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    static let identifier = "RecordTableViewCell"
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var passPercentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var memoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraint() {
        
        contentView.layer.borderWidth = 1
        
        // timeLabel과 passPercentLabel을 VStack에 넣어줌
        let leftLabelView = UIStackView()
        leftLabelView.translatesAutoresizingMaskIntoConstraints = false
        leftLabelView.axis = .vertical
        leftLabelView.spacing = 5
        leftLabelView.distribution = .fillEqually
        contentView.addSubview(leftLabelView) // Unable to activate constraint with anchors 오류 해결
        
        leftLabelView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        leftLabelView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        leftLabelView.addArrangedSubview(timeLabel)
        leftLabelView.addArrangedSubview(passPercentLabel)
        
        timeLabel.leadingAnchor.constraint(equalTo: leftLabelView.leadingAnchor).isActive = true
        passPercentLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10).isActive = true
        passPercentLabel.leadingAnchor.constraint(equalTo: leftLabelView.leadingAnchor).isActive = true
        
        contentView.addSubview(memoLabel)
        memoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        memoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        // width 지정 안해주면 왼쪽으로 계속 넘침
        memoLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }

}
