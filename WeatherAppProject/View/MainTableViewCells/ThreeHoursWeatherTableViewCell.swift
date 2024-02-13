//
//  ThreeHoursWeatherTableViewCell.swift
//  WeatherAppProject
//
//  Created by Madeline on 2/11/24.
//

import SnapKit
import UIKit

class ThreeHoursWeatherTableViewCell: BaseTableViewCell {

    var forecastData: [List]?
    var iconCode : String = "" {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionLayout())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecastData: [List]) {
        let now = Date()
        let calendar = Calendar.current
        
        self.forecastData = forecastData.filter { data in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: data.dtTxt) {
                return date > now
            }
            return false
        }
        
        self.collectionView.reloadData()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .black
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ThreeHoursWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "ThreeHoursWeatherCollectionViewCell")
    }
    
    static func configureCollectionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.18)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        
        return layout
    }
}

extension ThreeHoursWeatherTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThreeHoursWeatherCollectionViewCell", for: indexPath) as! ThreeHoursWeatherCollectionViewCell
        
        if indexPath.row == 0 {
            
            cell.time.text = "지금"
            
            if let firstData = forecastData?.first {
                cell.configure(with: firstData)
            }
        } else {
            
            if let data = forecastData, indexPath.row - 1 < data.count {
                let actualIndex = indexPath.row - 1
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date = dateFormatter.date(from: data[actualIndex].dtTxt) {
                    dateFormatter.dateFormat = "H시"
                    let timeString = dateFormatter.string(from: date)
                    cell.time.text = timeString
                    cell.configure(with: data[actualIndex])
                }
            }
        }

        return cell
    }

}

#Preview {
    ThreeHoursWeatherTableViewCell()
}
