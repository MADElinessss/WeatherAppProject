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
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("지도 로드 완료")
    }
    
    // 지도 로딩 실패 시 호출되는 메서드
    func mapView(_ mapView: MKMapView, didFailToLoadMapWithError error: Error) {
        print("지도 로드 실패: \(error.localizedDescription)")
    }
    
    func configureWithLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        print("Configuring map with location: latitude \(latitude), longitude \(longitude)")
                
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 400, longitudinalMeters: 400)
        mapView.setRegion(region, animated: true)
        print("Map region set to: \(region)")
    }

//
//    func configureWithLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
//        mapView.setRegion(region, animated: true)
//        
//        mapView.removeAnnotations(mapView.annotations)
//        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location
//        mapView.addAnnotation(annotation)
//    }
    
    func configureBackgroundColor(_ color: UIColor) {
        contentView.backgroundColor = color
    }
    
}
