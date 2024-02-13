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

class LocationMapTableViewCell: BaseTableViewCell, MKMapViewDelegate {
    
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
        
        mapView.delegate = self
        mapView.mapType = .standard
        
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    func configureWithLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
                 
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 400, longitudinalMeters: 400)
        mapView.setRegion(region, animated: true)
    }

    func configureBackgroundColor(_ color: UIColor) {
        contentView.backgroundColor = color
    }
    
}
