//
//  CitySearchViewController.swift
//  WeatherAppProject
//
//  Created by Madeline on 2/13/24.
//

import SnapKit
import UIKit

class CitySearchViewController: BaseViewController {
    
    var onCitySelected: ((_ lat: String, _ lon: String) -> Void)?
    
    var citylist: [CityList] = []
    
    let titleLabel = UILabel()
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        loadAndParseJson()
    }
    
    override func configureHeirarchy() {
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(60)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        titleLabel.text = "City"
        titleLabel.font = .systemFont(ofSize: 48, weight: .bold)
        titleLabel.textColor = .white
        
        searchBar.placeholder = "Search for a city."
        searchBar.barTintColor = .black
        searchBar.searchTextField.backgroundColor = .darkGray
        let placeholderTextColor = UIColor.lightGray
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search for a city.", attributes: [NSAttributedString.Key.foregroundColor: placeholderTextColor])
        if let textField = searchBar.value(forKey: "searchField") as? UITextField,
           let glassIconView = textField.leftView as? UIImageView {
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = .white
        }
        
        let leftItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftBarButtonItemTapped))
        navigationItem.leftBarButtonItem = leftItem
        leftItem.tintColor = .white
        
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
        navigationItem.rightBarButtonItem = rightItem
        rightItem.tintColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .black
        
    }
    
    @objc func leftBarButtonItemTapped() {
        dismiss(animated: true)
    }
    
    @objc func rightBarButtonItemTapped() {
        // 액션 구현
    }
}

extension CitySearchViewController {
    func loadAndParseJson() {
        if let url = Bundle.main.url(forResource: "CityList", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                citylist = try JSONDecoder().decode([CityList].self, from: data)
                //                print(citylist)
                tableView.reloadData()
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
}

extension CitySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let city = citylist[indexPath.row]
        cell.backgroundColor = .black
        cell.textLabel?.text = "# \(city.name), \(city.country)"
        cell.textLabel?.textColor = .white
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = citylist[indexPath.row]
        let selectedLat = String(selectedCity.coord.lat)
        let selectedLon = String(selectedCity.coord.lon)
        
        onCitySelected?(selectedLat, selectedLon)

        self.dismiss(animated: true, completion: nil)
    }
}

#Preview {
    CitySearchViewController()
}
