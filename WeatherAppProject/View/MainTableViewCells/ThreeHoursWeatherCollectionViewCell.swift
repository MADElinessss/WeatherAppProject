//
//  ThreeHoursWeatherCollectionViewCell.swift
//  WeatherAppProject
//
//  Created by Madeline on 2/11/24.
//

import SnapKit
import UIKit

class ThreeHoursWeatherCollectionViewCell: BaseCollectionViewCell {
    
    let time = UILabel()
    let image = UIImageView()
    let temperature = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        contentView.addSubview(time)
        contentView.addSubview(image)
        contentView.addSubview(temperature)
    }
    
    override func configureLayout() {
        time.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        image.snp.makeConstraints { make in
            make.top.equalTo(time.snp.bottom).inset(8)
            make.centerX.equalTo(contentView)
        }
        
        temperature.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).inset(8)
            make.centerX.equalTo(contentView)
        }
    }
    
    override func configureView() {
        
        time.text = "12시"
        time.font = .systemFont(ofSize: 14, weight: .light)
        time.textColor = .white
        
        image.image = UIImage(systemName: "cloud.fill")
        image.tintColor = .white
        
        temperature.text = "7°"
        temperature.font = .systemFont(ofSize: 14, weight: .light)
        temperature.textColor = .white
    }
}
