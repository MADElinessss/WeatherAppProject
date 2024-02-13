//
//  LocationMapTableViewCell.swift
//  WeatherAppProject
//
//  Created by Madeline on 2/11/24.
//

import CoreLocation
import MapKit
import SnapKit
import UIKit

class LocationMapTableViewCell: BaseTableViewCell {
    
    let mapView = MKMapView()
    let manager = CLLocationManager()
    
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
    }
    
    func configureWithLocation(location: CLLocationCoordinate2D) {
        let center = location
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }

    func configureBackgroundColor(_ color: UIColor) {
        contentView.backgroundColor = color
    }

}
