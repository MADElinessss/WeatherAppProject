//
//  ViewController.swift
//  WeatherAppProject
//
//  Created by Madeline on 2/11/24.
//

import CoreLocation
import SnapKit
import UIKit

class ViewController: BaseViewController {
    
    var onCitySelected: ((String, String) -> Void)?
    
    let mainTableView = UITableView()
    let footerView = UIView()
    let mapButton = UIButton()
    let listButton = UIButton()
    
    var weatherList: WeatherModel?
    var forecastList: ForecastModel?
    var dailyWeatherList: [DailyWeather] = []
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        checkDeviceLocationAuthorization()
        
        loadWeatherData()
    }
    
    func setCityId(_ cityLat: String, _ cityLon: String) {
        onCitySelected?(cityLat, cityLon)
        loadWeatherData()
    }
    
    // MARK: 날씨 API 호출
    func loadWeatherData(lat: String? = nil, lon: String? = nil) {
        
        let latitude: String
        let longitude: String
        
        if let lat = lat, let lon = lon {
            latitude = lat
            longitude = lon
        } else if let currentLocation = self.currentLocation {
            latitude = "\(currentLocation.latitude)"
            longitude = "\(currentLocation.longitude)"
        } else {
            print("현재 위치를 사용할 수 없습니다.")
            return
        }
        
        let currentAPI = WeatherAPI.current(lat: latitude, lon: longitude)
        
        APIManager.shared.fetchWeather(type: WeatherModel.self, api: currentAPI, url: currentAPI.endPoint) { [weak self] weather, error in
            DispatchQueue.main.async {
                if let weatherList = weather {
                    self?.weatherList = weatherList
                    self?.mainTableView.reloadData()
                    if let weatherConditionCode = weatherList.weather.first?.id {
                        self?.updateBackgroundColor(withWeatherConditionCode: weatherConditionCode)
                        
                    }
                } else {
                    print(error)
                }
            }
        }
        
        let forecastAPI = WeatherAPI.forecast(lat: latitude, lon: longitude)
        APIManager.shared.fetchWeather(type: ForecastModel.self, api: forecastAPI, url: forecastAPI.endPoint) { forecast, error in
            DispatchQueue.main.async {
                if let forecastList = forecast {
                    self.forecastList = forecastList
                    self.updateDailyWeatherList()
                    self.mainTableView.reloadData()
                } else {
                    print(error)
                }
            }
        }
    }
    
    func updateBackgroundColor(withWeatherConditionCode code: Int) {
        let backgroundColor = BackgroundColorManager.shared.backgroundColor(forWeatherConditionCode: code, atTime: Date())
        DispatchQueue.main.async { [weak self] in
            self?.view.backgroundColor = backgroundColor
            self?.mainTableView.backgroundColor = backgroundColor
        }
    }
    
    override func configureHeirarchy() {
        view.addSubview(mainTableView)
        view.addSubview(footerView)
        view.addSubview(mapButton)
        view.addSubview(listButton)
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
        
        footerView.tintColor = .lightGray
        footerView.backgroundColor = .lightGray
        footerView.layer.backgroundColor = UIColor.lightGray.cgColor
        
        mapButton.setImage(UIImage(systemName: "map"), for: .normal)
        mapButton.tintColor = .white
        mapButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        
        listButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        listButton.tintColor = .white
    }
    
    @objc func mapButtonTapped() {
        let vc = CitySearchViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
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
            return UIScreen.main.bounds.height * 0.2
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
            return dailyWeatherList.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
            
            let weatherConditionCode = weatherList?.weather.first?.id ?? 0
            let backgroundColor = BackgroundColorManager.shared.backgroundColor(forWeatherConditionCode: weatherConditionCode, atTime: Date())
            
            cell.configureBackgroundColor(backgroundColor)
            
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
            
            let weatherConditionCode = weatherList?.weather.first?.id ?? 0
            
            let backgroundColor = BackgroundColorManager.shared.backgroundColor(forWeatherConditionCode: weatherConditionCode, atTime: Date())
            cell.configureBackgroundColor(backgroundColor)
            
            if let forecastData = forecastList?.list {
                cell.configure(with: forecastData)
                let iconCode = forecastData.first?.weather.first?.icon ?? ""
                cell.iconCode = iconCode
            }
            
            cell.selectionStyle = .none
            
            return cell
            
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FiveDaysWeatherTableViewCell", for: indexPath) as! FiveDaysWeatherTableViewCell
            
            let weatherConditionCode = weatherList?.weather.first?.id ?? 0
            let backgroundColor = BackgroundColorManager.shared.backgroundColor(forWeatherConditionCode: weatherConditionCode, atTime: Date())
            
            cell.configureBackgroundColor(backgroundColor)
            
            let dailyWeather = dailyWeatherList[indexPath.row]
            let dayString = dayOfWeekString(from: dailyWeather.date)
            cell.date.text = dayString
            
            let tempMaxCelsius = dailyWeather.maxTemp - 273.15
            let tempMinCelsius = dailyWeather.minTemp - 273.15
            cell.maxTemperature.text = "최고 \(String(format: "%.0f°", tempMaxCelsius))"
            cell.minTemperature.text = "최저 \(String(format: "%.0f°", tempMinCelsius))"
            
            if let weather = forecastList?.list[indexPath.row].weather.first {
                let iconCode = weather.icon
                let iconUrl = URL(string: "https://openweathermap.org/img/wn/\(iconCode).png")
                loadImage(from: iconUrl, for: cell.weatherIcon)
            }
            
            cell.selectionStyle = .none
            
            return cell
        } else if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationMapTableViewCell", for: indexPath) as! LocationMapTableViewCell
            
            let weatherConditionCode = weatherList?.weather.first?.id ?? 0
            let backgroundColor = BackgroundColorManager.shared.backgroundColor(forWeatherConditionCode: weatherConditionCode, atTime: Date())
            
            cell.configureBackgroundColor(backgroundColor)
            
            // TODO: 현위치 지도, 현재 위치를 받아와야 함
            if let currentLocation = self.currentLocation {
                // 올바른 인자 레이블과 함께 메소드 호출
                cell.configureWithLocation(location: currentLocation)
            }
            
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "FiveDaysWeatherTableViewCell", for: indexPath) as! FiveDaysWeatherTableViewCell
            
            let weatherConditionCode = weatherList?.weather.first?.id ?? 0
            let backgroundColor = BackgroundColorManager.shared.backgroundColor(forWeatherConditionCode: weatherConditionCode, atTime: Date())
            
            cell.configureBackgroundColor(backgroundColor)
            
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
    func loadImage(from url: URL?, for imageView: UIImageView) {
        guard let url = url else { return }
        
        // 이미지 데이터 로드
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }.resume()
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location.coordinate
        
        locationManager.stopUpdatingLocation()
        
        loadWeatherData()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted, .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func checkDeviceLocationAuthorization() {
        let status = CLLocationManager.authorizationStatus() // iOS 14 미만 대응
        if #available(iOS 14.0, *) {
            let status = locationManager.authorizationStatus // iOS 14 이상 대응
        }
        
        switch status {
        case .notDetermined:
            // 권한이 결정되지 않음: 권한 요청
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // 권한이 제한됨 또는 거부됨: 사용자에게 설정에서 권한을 변경하도록 안내
            DispatchQueue.main.async {
                self.showLocationAccessDeniedAlert()
            }
        case .authorizedAlways, .authorizedWhenInUse:
            // 권한이 허용됨: 위치 업데이트 시작
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func showLocationAccessDeniedAlert() {
        let alert = UIAlertController(title: "위치 서비스 권한 필요", message: "이 앱은 정확한 날씨 정보를 제공하기 위해 위치 서비스 권한이 필요합니다. 설정에서 권한을 허용해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func checkCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .authorized:
            print("authorized")
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
    
    func updateDailyWeatherList() {
        guard let forecastList = forecastList else { return }
        
        var tempDailyWeatherList: [DailyWeather] = []
        let calendar = Calendar.current
        
        for forecast in forecastList.list {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            guard let date = dateFormatter.date(from: forecast.dtTxt) else { continue }
            let startOfDay = calendar.startOfDay(for: date)
            
            if let existingIndex = tempDailyWeatherList.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: startOfDay) }) {
                // Update existing daily weather with new max/min temps if needed
                tempDailyWeatherList[existingIndex].maxTemp = max(tempDailyWeatherList[existingIndex].maxTemp, forecast.main.tempMax)
                tempDailyWeatherList[existingIndex].minTemp = min(tempDailyWeatherList[existingIndex].minTemp, forecast.main.tempMin)
            } else {
                // Add new daily weather
                let newDailyWeather = DailyWeather(date: startOfDay, maxTemp: forecast.main.tempMax, minTemp: forecast.main.tempMin)
                tempDailyWeatherList.append(newDailyWeather)
            }
        }
        
        self.dailyWeatherList = tempDailyWeatherList
    }
    
}


#Preview {
    ViewController()
}
