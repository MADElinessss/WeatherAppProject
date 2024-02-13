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
        
        if let iconCode = data.weather.first?.icon {
            guard let iconUrl = URL(string: "https://openweathermap.org/img/wn/\(iconCode).png") else { return }
            ImageManager.shared.loadImage(from: iconUrl) { [weak self] image, error in
                guard let self = self else { return }
                if let image = image {
                    DispatchQueue.main.async {
                        self.image.image = image
                    }
                } else if let error = error {
                    print("Error loading image: \(error)")
                }
            }
        }
        
        // 날짜 및 시간 설정
        let dateString = data.dtTxt
        self.time.text = extractHourString(from: dateString)
        
        // 온도 설정
        let temperatureCelsius = data.main.temp - 273.15
        self.temperature.text = String(format: "%.0f°", temperatureCelsius)
        
    }

    override func configureHierarchy() {
        contentView.backgroundColor = .black
        contentView.addSubview(time)
        contentView.addSubview(image)
        contentView.addSubview(temperature)
    }
    
    override func configureLayout() {
        time.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
        
        image.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.centerX.equalTo(contentView)
        }
        
        temperature.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.centerX.equalTo(contentView)
        }
    }
    
    override func configureView() {
        
        time.text = "12시"
        time.font = .systemFont(ofSize: 18, weight: .light)
        time.textColor = .white
        
        image.image = UIImage(systemName: "cloud.fill")
        image.tintColor = .white
        
        temperature.text = "7°"
        temperature.font = .systemFont(ofSize: 20, weight: .light)
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
