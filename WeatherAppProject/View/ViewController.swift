//
//  ViewController.swift
//  WeatherAppProject
//
//  Created by Madeline on 2/11/24.
//

import SnapKit
import UIKit

/*
 Tableview
 footerview
 */
class ViewController: BaseViewController {
    
    let mainTableView = UITableView()
    
    var weatherList: WeatherModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWeatherData()
        
    }
    
    func loadWeatherData() {
        let api = WeatherAPI.current(lat: "33.4890", lon: "126.4983")
        APIManager.shared.fetchWeather(type: WeatherModel.self, api: api, url: api.endPoint) { [weak self] weather, error in
            DispatchQueue.main.async {
                if let weatherList = weather {
                    self?.weatherList = weatherList
                    self?.mainTableView.reloadData()
                } else {
                    print(error)
                }
            }
        }
    }

    
    override func configureHeirarchy() {
        view.addSubview(mainTableView)
    }
    
    override func configureLayout() {
        mainTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        mainTableView.register(ThreeHoursWeatherTableViewCell.self, forCellReuseIdentifier: "ThreeHoursWeatherTableViewCell")
        
//        mainTableView.backgroundColor = .black
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UIScreen.main.bounds.height * 0.5
        } else {
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
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "ThreeHoursWeatherTableViewCell", for: indexPath) as! ThreeHoursWeatherTableViewCell
            
            
            return cell
        } else {
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
            
            cell.location.text = weatherList?.name
            
            let temperature = (weatherList?.main.temp ?? 273.15) - 273.15
            cell.temperature.text = String(format: "%.1f°C", temperature)
            
            let tempMax = (weatherList?.main.tempMax ?? 273.15) - 273.15
            let tempMin = (weatherList?.main.tempMin ?? 273.15) - 273.15
            cell.highAndLowDegree.text = "최고 : \(String(format: "%.1f°C", tempMax))  |  최저 : \(String(format: "%.1f°C", tempMin))"
            
            cell.weather.text = weatherList?.weather.first?.main
            
            return cell
        }
    }
    
}

