//
//  ViewController.swift
//  WeatherAppProject
//
//  Created by Madeline on 2/11/24.
//

import SnapKit
import UIKit

class ViewController: BaseViewController {
    
    let mainTableView = UITableView()
    let footerView = UIView()
    let mapButton = UIButton()
    let listButton = UIButton()
    
    var weatherList: WeatherModel?
    var forecastList: ForecastModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWeatherData()
        
    }
    
    func loadWeatherData() {
        let currentAPI = WeatherAPI.current(lat: "33.4890", lon: "126.4983")
        APIManager.shared.fetchWeather(type: WeatherModel.self, api: currentAPI, url: currentAPI.endPoint) { [weak self] weather, error in
            DispatchQueue.main.async {
                if let weatherList = weather {
                    self?.weatherList = weatherList
                    self?.mainTableView.reloadData()
                } else {
                    print(error)
                }
            }
        }
        let forecastAPI = WeatherAPI.forecast(lat: "33.4890", lon: "126.4983")
        APIManager.shared.fetchWeather(type: ForecastModel.self, api: forecastAPI, url: forecastAPI.endPoint) { forecast, error in
            DispatchQueue.main.async {
                if let forecastList = forecast {
                    self.forecastList = forecastList
                    self.mainTableView.reloadData()
                } else {
                    print(error)
                }
            }
        }
    }
    
    
    override func configureHeirarchy() {
        view.addSubview(mainTableView)
        view.addSubview(footerView)
        footerView.addSubview(mapButton)
        footerView.addSubview(listButton)
    }
    
    override func configureLayout() {
        mainTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(footerView.snp.top)
        }
        footerView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).inset(24)
            make.height.equalTo(44)
        }
        mapButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(footerView)
        }
        listButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(footerView)
        }
    }
    
    override func configureView() {
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        mainTableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        mainTableView.register(ThreeHoursWeatherTableViewCell.self, forCellReuseIdentifier: "ThreeHoursWeatherTableViewCell")
        mainTableView.register(LocationMapTableViewCell.self, forCellReuseIdentifier: "LocationMapTableViewCell")
        mainTableView.register(FiveDaysWeatherTableViewCell.self, forCellReuseIdentifier: "FiveDaysWeatherTableViewCell")
        
        mainTableView.backgroundColor = .black
        
        footerView.tintColor = .lightGray
        footerView.backgroundColor = .lightGray
        footerView.layer.backgroundColor = UIColor.lightGray.cgColor
        
        mapButton.setImage(UIImage(systemName: "map"), for: .normal)
        mapButton.tintColor = .white
        
        
        listButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        listButton.tintColor = .white
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "🕒 3시간 간격의 일기 예보"
        } else if section == 2 {
            return "🗓️ 5일 간의 일기 예보"
        } else if section == 3 {
            return "🌡️ 위치"
        } else {
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    // MARK: 섹션 별 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UIScreen.main.bounds.height * 0.35
        } else if indexPath.section == 1 {
            // 3시간 간격의 날씨
            return UIScreen.main.bounds.height * 0.18
        } else if indexPath.section == 2 {
            // 5일 동안의 날씨
            return 44
        } else {
            // 지도
            return UIScreen.main.bounds.height * 0.4
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 5
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
            
            cell.location.text = weatherList?.name
            
            let temperature = (weatherList?.main.temp ?? 273.15) - 273.15
            cell.temperature.text = String(format: "%.1f°", temperature)
            
            let tempMax = (weatherList?.main.tempMax ?? 273.15) - 273.15
            let tempMin = (weatherList?.main.tempMin ?? 273.15) - 273.15
            cell.highAndLowDegree.text = "최고 : \(String(format: "%.1f°", tempMax))  |  최저 : \(String(format: "%.1f°", tempMin))"
            
            cell.weather.text = weatherList?.weather.first?.main
            
            cell.selectionStyle = .none
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThreeHoursWeatherTableViewCell", for: indexPath) as! ThreeHoursWeatherTableViewCell
            
            if let forecastData = forecastList?.list {
                cell.configure(with: forecastData)
            }
            
            cell.selectionStyle = .none
            
            return cell
            
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FiveDaysWeatherTableViewCell", for: indexPath) as! FiveDaysWeatherTableViewCell
            
            let dayString = dateStringForIndexPath(indexPath, isHourly: false)
            cell.date.text = dayString
            
            if let tempMax = forecastList?.list[indexPath.row * 8].main.tempMax, let tempMin = forecastList?.list[indexPath.row * 8].main.tempMin {
                let tempMaxCelsius = tempMax - 273.15
                let tempMinCelsius = tempMin - 273.15
                cell.maxTemperature.text = "최고 \(String(format: "%.0f°", tempMaxCelsius))"
                cell.minTemperature.text = "최저 \(String(format: "%.0f°", tempMinCelsius))"
            }
            cell.selectionStyle = .none
            
            return cell

        } else if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationMapTableViewCell", for: indexPath) as! LocationMapTableViewCell
            
            // TODO: 현위치 지도, 현재 위치를 받아와야 함
            
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "FiveDaysWeatherTableViewCell", for: indexPath) as! FiveDaysWeatherTableViewCell
            
            let dayString = dateStringForIndexPath(indexPath, isHourly: false)
            cell.date.text = dayString
            if let tempMax = forecastList?.list[indexPath.row * 8].main.tempMax {
                cell.maxTemperature.text = "최고 \(tempMax - 273.15)°"
            }
            
            if let tempMin = forecastList?.list[indexPath.row * 8].main.tempMin {
                cell.minTemperature.text = "최저 \(tempMin - 273.15)°"
            }
            
            // TODO: icon
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

extension ViewController {
    // 시간 정보를 추출하는 함수
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
    
    // 요일 문자열을 생성하는 함수
    func dayOfWeekString(from date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "오늘"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            return dateFormatter.string(from: date)
        }
    }
    
    func dateStringForIndexPath(_ indexPath: IndexPath, isHourly: Bool) -> String {
        guard let forecastList = forecastList, indexPath.row < forecastList.list.count else { return "" }
        
        let dateString = forecastList.list[indexPath.row].dtTxt
        if isHourly {
            return extractHourString(from: dateString)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            guard let date = dateFormatter.date(from: dateString) else { return "" }
            return dayOfWeekString(from: date)
        }
    }
}

#Preview {
    ViewController()
}
