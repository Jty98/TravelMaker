//
//  test.swift
//  TravelMaker
//
//  Created by ms k on 2023/09/25.
//

import UIKit
import CoreLocation
import NMapsMap

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*-------위치 정보 가져오기--------*/
        //delegate설정
        locationManager.delegate = self
        //거리정확도 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //사용자에게 허용받기 alert띄우기
        locationManager.requestWhenInUseAuthorization()
        
        //위치서비스 켜진상태
        if CLLocationManager.locationServicesEnabled(){
            print("위치서비스ON")
            locationManager.startUpdatingLocation()//위치정보 받아오기
            print(locationManager.location?.coordinate)
        }else{
            print("위치서비스OFF")
        }
        
        //맵띄우기
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
        
        
    }

    
}
