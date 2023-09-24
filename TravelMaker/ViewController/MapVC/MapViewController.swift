//
//  MapViewController.swift
//  TravelMaker
//
//  Created by ms k on 2023/09/22.
//

import UIKit
import CoreLocation
import NMapsMap

class MapViewController: UIViewController {
    
//    var naverMapView = NMFNaverMapView()
    //출발지 마커
    let marker = NMFMarker()
    var mapView = NMFMapView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //맵띄우기
        mapView = NMFMapView(frame: view.frame)
        let cameraposition = mapView.cameraPosition
        print(cameraposition)
        view.addSubview(mapView)
        
        setCamera()
        setMarker()
//        setPath()
        
    }
    func setCamera() {
        let camPosition =  NMGLatLng(lat: 33.507103403, lng:126.492794153)
        let cameraUpdate = NMFCameraUpdate(scrollTo: camPosition)
        mapView.moveCamera(cameraUpdate)
    }
    func setMarker() {
        marker.position = NMGLatLng(lat: 33.507103403, lng:126.492794153)
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = UIColor.red
        marker.width = 50
        marker.height = 60
        marker.mapView = mapView
        
        // 정보창 생성
        let infoWindow = NMFInfoWindow()
        let dataSource = NMFInfoWindowDefaultTextSource.data()
        dataSource.title = "제주국제공항"
        infoWindow.dataSource = dataSource
        
        // 마커 달아주기
        infoWindow.open(with: marker)

    }
    
    //<<<<<<<<<<<<<<<<<<길만들어주고 싶을 때 사용>>>>>>>>>>>>>>>>>>>>
    //viewdidload에 setPath()만 갖다 쓰면 됌.
//    func setPath(){
//        let pathOverlay = NMFPath()
//        pathOverlay.color = .red            // pathOverlay의 색
//        pathOverlay.outlineColor = .blue    // pathOverlay 테두리 색
//        pathOverlay.width = 10              // pathOverlay 두께
//                    
//        // pathOverlay 경로를 설정합니다.
//        pathOverlay.path = NMGLineString(points: [
//                NMGLatLng(lat: 37.57152, lng: 126.97714),
//                NMGLatLng(lat: 37.56607, lng: 126.98268),
//                NMGLatLng(lat: 37.56445, lng: 126.97707),
//                NMGLatLng(lat: 37.55855, lng: 126.97822)
//        ])
//        pathOverlay.mapView = mapView
//    }

    

}//원본



//import UIKit
//import CoreLocation
//import NMapsMap
//
//class MainViewController: UIViewController, CLLocationManagerDelegate {
//    
//    var locationManager = CLLocationManager()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        /*-------위치 정보 가져오기--------*/
//        //delegate설정
//        locationManager.delegate = self
//        //거리정확도 설정
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        //사용자에게 허용받기 alert띄우기
//        locationManager.requestWhenInUseAuthorization()
//        
//        //위치서비스 켜진상태
//        if CLLocationManager.locationServicesEnabled(){
//            print("위치서비스ON")
//            locationManager.startUpdatingLocation()//위치정보 받아오기
//            print(locationManager.location?.coordinate)
//        }else{
//            print("위치서비스OFF")
//        }
//        
//        //맵띄우기
//        let mapView = NMFMapView(frame: view.frame)
//        view.addSubview(mapView)
//        
//        
//    }
//
//    
//}









//import CoreLocation
//import NMapsMap
//
//class MainViewController: UIViewController, CLLocationManagerDelegate {
//    
//    var locationManager = CLLocationManager()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let mapView = NMFMapView(frame: view.frame)
//        view.addSubview(mapView)
//        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        
//        if CLLocationManager.locationServicesEnabled() {
//            print("위치 서비스 On 상태")
//            locationManager.startUpdatingLocation()
//            print(locationManager.location?.coordinate as Any)
//        } else {
//            print("위치 서비스 Off 상태")
//        }
//
//    }
//    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
//        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            print("didUpdateLocations")
//            if let location = locations.first {
//                print("위도: \(location.coordinate.latitude)")
//                print("경도: \(location.coordinate.longitude)")
//            }
//        }
//        
//        // 위도 경도 받아오기 에러
//        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//            print(error)
//        }
//
//    
//}



//현재 위치 받아오기 까지... 근데 안됌.
//import UIKit
//import CoreLocation
//import NMapsMap
//
//class MainViewController: UIViewController, CLLocationManagerDelegate {
//    
//    var locationManager = CLLocationManager()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let mapView = NMFMapView(frame: view.frame)
//        view.addSubview(mapView)
//        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        
//        if CLLocationManager.locationServicesEnabled() {
//            print("위치 서비스 On 상태")
//            locationManager.startUpdatingLocation()
//            print(locationManager.location?.coordinate)
//            
//            //현 위치로 카메라 이동
//            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
//            cameraUpdate.animation = .easeIn
//            mapView.moveCamera(cameraUpdate)
//            
//            let marker = NMFMarker()
//            marker.position = NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0)
//            marker.mapView = mapView
//            
//        } else {
//            print("위치 서비스 Off 상태")
//        }
//
//    }
//}

