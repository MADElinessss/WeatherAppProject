//
//  MainTableViewCell.swift
//  WeatherAppProject
//
//  Created by Madeline on 2/11/24.
//

import SnapKit
import UIKit

class MainTableViewCell: BaseTableViewCell {
    
    let location = UILabel()
    let temperature = UILabel()
    let weather = UILabel()
    let highAndLowDegree = UILabel()
    let background = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        contentView.addSubview(background)
        contentView.addSubview(location)
        contentView.addSubview(temperature)
        contentView.addSubview(weather)
        contentView.addSubview(highAndLowDegree)
    }
    
    override func configureLayout() {
        background.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        location.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(24)
            make.centerX.equalTo(contentView)
        }
        temperature.snp.makeConstraints { make in
            make.top.equalTo(location.snp.bottom)
            make.centerX.equalTo(contentView)
        }
        weather.snp.makeConstraints { make in
            make.top.equalTo(temperature.snp.bottom)
            make.centerX.equalTo(contentView)
        }
        highAndLowDegree.snp.makeConstraints { make in
            make.top.equalTo(weather.snp.bottom).inset(-6)
            make.centerX.equalTo(contentView)
        }
    }
    
    override func configureView() {
        background.backgroundColor = .black
        location.text = "Jeju City"
        location.font = .systemFont(ofSize: 44, weight: .light)
        location.textColor = .white
        
        temperature.text = "5.9°"
        temperature.font = .systemFont(ofSize: 100, weight: .thin)
        temperature.textColor = .white
        
        weather.text = "Broken Clouds"
        weather.font = .systemFont(ofSize: 24, weight: .medium)
        weather.textColor = .white
        
        highAndLowDegree.text = "최고 : 7.0°  |  최저 : -4.2°"
        highAndLowDegree.font = .systemFont(ofSize: 20, weight: .medium)
        highAndLowDegree.textColor = .white
    }
    
}

#Preview {
    MainTableViewCell()
}
