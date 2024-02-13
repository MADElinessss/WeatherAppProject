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
    
    func configure(with data: List) {
        
        let dateString = data.dtTxt
        self.time.text = extractHourString(from: dateString)
        
        let temperatureCelsius = data.main.temp - 273.15
        self.temperature.text = String(format: "%.0f°", temperatureCelsius)
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
            make.top.equalTo(time.snp.bottom).inset(-8)
            make.centerX.equalTo(contentView)
        }
        
        temperature.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).inset(-8)
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

extension ThreeHoursWeatherCollectionViewCell {
    func extractHourString(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "ko_KR")
        
        guard let date = inputFormatter.date(from: dateString) else { return "" }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "H시"
        outputFormatter.locale = Locale(identifier: "ko_KR")
        
        return outputFormatter.string(from: date)
    }
}

#Preview {
    ThreeHoursWeatherCollectionViewCell()
}
