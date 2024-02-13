//
//  FiveDaysWeatherTableViewCell.swift
//  WeatherAppProject
//
//  Created by Madeline on 2/11/24.
//

import SnapKit
import UIKit

class FiveDaysWeatherTableViewCell: BaseTableViewCell {
    
    let date = UILabel()
    let weatherIcon = UIImageView()
    let minTemperature = UILabel()
    let maxTemperature = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureBackgroundColor(_ color: UIColor) {
        contentView.backgroundColor = color
    }
    
    override func configureView() {
        contentView.addSubview(date)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(minTemperature)
        contentView.addSubview(maxTemperature)
        
        date.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(28)
            make.centerY.equalTo(contentView)
        }
        weatherIcon.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(110)
            make.centerY.equalTo(contentView)
            make.height.equalTo(24)
        }
        minTemperature.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView)
        }
        maxTemperature.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-48)
            make.centerY.equalTo(contentView)
        }
        
        date.text = "오늘"
        date.font = .systemFont(ofSize: 24, weight: .light)
        date.textColor = .white

        weatherIcon.image = UIImage(systemName: "sun.max.fill")
        weatherIcon.tintColor = .yellow
        weatherIcon.contentMode = .scaleAspectFill
        
        minTemperature.text = "최저 -2°"
        minTemperature.font = .systemFont(ofSize: 18, weight: .light)
        minTemperature.textColor = .systemGray6
        
        maxTemperature.text = "최고 9°"
        maxTemperature.font = .systemFont(ofSize: 18, weight: .light)
        maxTemperature.textColor = .white
    }

}

#Preview {
    FiveDaysWeatherTableViewCell()
}
