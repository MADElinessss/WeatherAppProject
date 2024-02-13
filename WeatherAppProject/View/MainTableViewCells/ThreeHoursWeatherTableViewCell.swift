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
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionLayout())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with forecastData: [List]) {
        self.forecastData = forecastData
        self.collectionView.reloadData()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ThreeHoursWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "ThreeHoursWeatherCollectionViewCell")
    }
    
    static func configureCollectionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumLineSpacing = 8
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
        
        if let data = forecastData?[indexPath.row] {
            cell.configure(with: data)
        }
        
        return cell
    }
}

#Preview {
    ThreeHoursWeatherTableViewCell()
}
