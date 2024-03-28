//
//  RecordHomeView.swift
//  muscleMemory
//
//  Created by MadCow on 2024/3/27.
//

import UIKit

class RecordHomeView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let recordButton = CustomButton()
    private let leftButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "arrowtriangle.left.fill"), for: .normal)
        btn.tintColor = .black
        
        return btn
    }()
    private let dateLabel = UILabel()
    private let rightButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
        btn.tintColor = .black
        
        return btn
    }()
    
    let viewModel = RecordHomeViewModel()
    
    private var allRecordsDay: [Int] = []
    private var selectYear: Int = 0
    private var selectMonth: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        setUIComponents()
        setDate(year: viewModel.getCurrentYear(), month: viewModel.getCurrentMonth())
        setAllRecords()
        setButtonsAction()
    }
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setUIComponents() {
        recordButton.setTitle("일기쓰기", for: .normal)
        recordButton.backgroundColor = .systemBlue
        recordButton.addTarget(self, action: #selector(moveToRecordPage), for: .touchUpInside)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(recordButton)
        view.addSubview(leftButton)
        view.addSubview(dateLabel)
        view.addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            // 일기쓰기 버튼
            recordButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            recordButton.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            
            // 이전 월로 이동 버튼
            leftButton.leftAnchor.constraint(equalTo: collectionView.leftAnchor),
            leftButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            leftButton.widthAnchor.constraint(equalToConstant: 25),
            leftButton.heightAnchor.constraint(equalToConstant: 25),
            
            // 날짜 표시 Label
            dateLabel.leftAnchor.constraint(equalTo: leftButton.rightAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: -2),
            
            // 다음 월로 이동 버튼
            rightButton.leftAnchor.constraint(equalTo: dateLabel.rightAnchor, constant: 10),
            rightButton.bottomAnchor.constraint(equalTo: leftButton.bottomAnchor),
            rightButton.widthAnchor.constraint(equalToConstant: 25),
            rightButton.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    func setDate(year: Int, month: Int) {
        selectYear = year
        selectMonth = month
        dateLabel.text = "\(selectYear)년-\(selectMonth)월"
    }
    
    func setAllRecords() {
        allRecordsDay = viewModel.getTestRecordDay(year: selectYear, month: selectMonth)
    }
    
    func setButtonsAction() {
        leftButton.addTarget(self, action: #selector(toBeforeMonth), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(toNextMonth), for: .touchUpInside)
    }
    
    @objc func moveToRecordPage() {
        present(RecordCreateView(), animated: true)
    }
    
    @objc func toBeforeMonth() {
        if selectMonth <= 1 {
            selectYear -= 1
            selectMonth = 12
        } else {
            selectMonth -= 1
        }
        setDate(year: selectYear, month: selectMonth)
        reloadViewCollection()
    }
    
    @objc func toNextMonth() {
        if selectMonth >= 12 {
            selectYear += 1
            selectMonth = 1
        } else {
            selectMonth += 1
        }
        setDate(year: selectYear, month: selectMonth)
        reloadViewCollection()
    }
    
    private func reloadViewCollection() {
        setAllRecords()
        collectionView.reloadData()
    }
}

extension RecordHomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getDaysBy(year: selectYear, month: selectMonth)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordHomeViewCell", for: indexPath) as? RecordHomeViewCell else {
            return UICollectionViewCell()
        }
        
        let calendarDay = indexPath.item + 1
        cell.dayLabel.text = "\(calendarDay)"
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 10
        
        if allRecordsDay.contains(calendarDay) {
            cell.recordImage.image = UIImage(systemName: "circle.fill")
        } else {
            cell.recordImage.image = nil
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = indexPath.item
        print(day)
    }
}