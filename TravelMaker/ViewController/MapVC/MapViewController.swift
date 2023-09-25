//
//  MapViewController.swift
//  TravelMaker
//
//  Created by ms k on 2023/09/22.
//

//
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<원본이자 우리가 보여줄 코드.
import UIKit
import CoreLocation
import NMapsMap

class MapViewController: UIViewController{
    
    let marker = NMFMarker()
//    var mapView : NMFMapView!
    private lazy var naverMapView: NMFMapView = {
            let mapView = NMFMapView() // 지도 객체 생성
            mapView.allowsZooming = true // 줌 가능
            mapView.logoInteractionEnabled = false // 로고 터치 불가능
            mapView.allowsScrolling = true // 스크롤 가능
            return mapView
    }()
    
    var locationManager = CLLocationManager()
    
//    var locationManager: CLLocationManager = {
//        let manager = CLLocationManager()
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.requestAlwaysAuthorization()
//        return manager
//        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //<<<MapView>>>
        //맵띄우기
//        mapView = NMFMapView(frame: CGRect(x: 0, y: 191, width: 393, height: 393))
//        view.addSubview(mapView)
        naverMapView = NMFMapView(frame: CGRect(x: 0, y: 191, width: 393, height: 393))
        view.addSubview(naverMapView)
        //줌레벨
//        mapView.zoomLevel = 12
        naverMapView.zoomLevel = 12
        

//        mapView.positionMode = .direction
//        mapView.positionMode = .compass
//        let cameraposition = mapView.cameraPosition
//        print(cameraposition)
        //mapType지정
        naverMapView.mapType = .basic
        
        //함수 불러오기
        setCamera()
        setMarker()
        setLimitZoom()
//        setPath()
        
        //Location Delegate
        locationManager.delegate = self
        
       
    }//<<<<<<<<<<<viewDidLoad>>>>>>>>>>>

    
    //<<<<<<<<<<<<<<Location>>>>>>>>>>>>>>>
    //location권한획득
//    func locationAllow(){
//        switch locationManager.authorizationStatus {
//            case .authorizedWhenInUse, .authorizedAlways:
//                print("권한 있음")
//            case .notDetermined, .restricted, .denied:
//                print("권한 없음")
//                locationManager.requestWhenInUseAuthorization()
//            default:
//                break;
//        }
//    }
    //https://co-dong.tistory.com/73
    //===========위치서비스 활성화 여부 확인===========
    func checkUserDeviceLocationServiceAuthorization() {
        // 3.1
        guard CLLocationManager.locationServicesEnabled() else {
            // 시스템 설정으로 유도하는 커스텀 얼럿
            showRequestLocationServiceAlert()
            return
        }
        // 3.2
        let authorizationStatus: CLAuthorizationStatus
            
        // 앱의 권한 상태 가져오는 코드 (iOS 버전에 따라 분기처리)
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        }else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        // 권한 상태값에 따라 분기처리를 수행하는 메서드 실행
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    // ===========앱에대한 위치 권한이 부여된 상태인지 확인=============
    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // 사용자가 권한에 대한 설정을 선택하지 않은 상태
            
            // 권한 요청을 보내기 전에 desiredAccuracy 설정 필요
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // 권한 요청을 보낸다.
            locationManager.requestWhenInUseAuthorization()
                
        case .denied, .restricted:
            // 사용자가 명시적으로 권한을 거부했거나, 위치 서비스 활성화가 제한된 상태
            // 시스템 설정에서 설정값을 변경하도록 유도한다.
            // 시스템 설정으로 유도하는 커스텀 얼럿
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse:
            // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태
            // manager 인스턴스를 사용하여 사용자의 위치를 가져온다.
            locationManager.startUpdatingLocation()
            
        default:
            print("Default")
        }
    }
    //=============디바이스의 시스템 설정으로 유도하는 커스텀 얼럿==============

    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default) { [weak self] _ in
            async { await self?.viewDidLoad() }
        }
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
    
    
    //<<<<<<<<<<<<<<<<<<<<LocationEND>>>>>>>>>>>>>>>>>>>>>>
    //<<<<<<<<<<<<<Button>>>>>>>>>>>>
    @IBAction func getCurrentLocation(_ sender: UIButton) {
//        locationManager.startUpdatingLocation()
//        checkUserDeviceLocationServiceAuthorization()
        DispatchQueue.global(qos: .background).async {
               self.locationManager.startUpdatingLocation()
               self.checkUserDeviceLocationServiceAuthorization()
           }
       
    }
    
    @IBAction func zoomIn(_ sender: UIButton) {
        naverMapView.zoomLevel += 1
    }
    @IBAction func zoomOut(_ sender: UIButton) {
        naverMapView.zoomLevel -= 1
    }
    //<<<<<<<<<<<<<<ButtonEnd>>>>>>>>>>
    

    
    
    //카메라 위치
    func setCamera() {
        let camPosition =  NMGLatLng(lat: 33.507103403, lng:126.492794153)
        let cameraUpdate = NMFCameraUpdate(scrollTo: camPosition)
        naverMapView.moveCamera(cameraUpdate)
    }
    //마커
    func setMarker() {
        marker.position = NMGLatLng(lat: 33.507103403, lng:126.492794153)
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = UIColor.red
        marker.width = 50
        marker.height = 60
        marker.mapView = naverMapView
        
        // 정보창 생성
        let infoWindow = NMFInfoWindow()
        let dataSource = NMFInfoWindowDefaultTextSource.data()
        dataSource.title = "제주국제공항"
        infoWindow.dataSource = dataSource
        
        // 마커 달아주기
        infoWindow.open(with: marker)

    }
    //최소, 최대 줌 레벨 , 최대 영역 제한
    func setLimitZoom(){
        //최대 최소 줌레벨
        naverMapView.minZoomLevel = 9.0
        naverMapView.maxZoomLevel = 18.0
        //제주도 범위 제한
        naverMapView.extent = NMGLatLngBounds(southWestLat: 33.08, southWestLng: 126.04, northEastLat: 33.65, northEastLng: 127.15)
    }
  
    //<<<<<<<<<<<<<<<<<<길만들어주고 싶을 때 사용>>>>>>>>>>>>>>>>>>>>
    //viewdidload에 setPath()만 갖다 쓰면 됌.
//    func setPath(){
//        let pathOverlay = NMFPath()
//        pathOverlay.color = .red            // pathOverlay의 색
//        pathOverlay.outlineColor = .blue    // pathOverlay 테두리 색
//        pathOverlay.width = 10              // pathOverlay 두께
//                    
//        // pathOverlay 경로를 설정
//        pathOverlay.path = NMGLineString(points: [
//                NMGLatLng(lat: 37.57152, lng: 126.97714),
//                NMGLatLng(lat: 37.56607, lng: 126.98268),
//                NMGLatLng(lat: 37.56445, lng: 126.97707),
//                NMGLatLng(lat: 37.55855, lng: 126.97822)
//        ])
//        pathOverlay.mapView = mapView
//    }

    //지도에 콘텐츠 뜰 때 패딩값 지정
    //<<<<<<<<<<<<<<<<<<<<<<<추후 이벤트 추가 예정>>>>>>>>>>>>>>>>>>>>>>>>>
    func setPadding(){
        naverMapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
    }
    
   


}
extension MapViewController: CLLocationManagerDelegate {
    
    // 사용자의 위치를 성공적으로 가져왔을 때 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 위치 정보를 배열로 입력받는데, 마지막 index값이 가장 정확하다고 한다.
        if let coordinate = locations.last?.coordinate {
            // 사용자 위치 정보 사용
        }
        
        // startUpdatingLocation()을 사용하여 사용자 위치를 가져왔다면
        // 불필요한 업데이트를 방지하기 위해 stopUpdatingLocation을 호출
        locationManager.stopUpdatingLocation()
    }
    // 사용자가 GPS 사용이 불가한 지역에 있는 등 위치 정보를 가져오지 못했을 때 호출
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 이상)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
        checkUserDeviceLocationServiceAuthorization()
    }
    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 미만)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
        checkUserDeviceLocationServiceAuthorization()
    }
}



//원본>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>













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

