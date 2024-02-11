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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            return cell
        } else {
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "ThreeHoursWeatherTableViewCell", for: indexPath) as! ThreeHoursWeatherTableViewCell
            
            return cell
        }
        
    }
    
}

