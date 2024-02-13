//
//  LocationMapTableViewCell.swift
//  WeatherAppProject
//
//  Created by Madeline on 2/11/24.
//

import MapKit
import SnapKit
import UIKit

class LocationMapTableViewCell: BaseTableViewCell {
    
    let mapView = MKMapView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        contentView.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        // TODO: View 더 추가
    }
    
    func configureBackgroundColor(_ color: UIColor) {
        contentView.backgroundColor = color
    }
}
