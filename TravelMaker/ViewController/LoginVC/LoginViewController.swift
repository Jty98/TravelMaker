//
//  LoginViewController.swift
//  TravelMaker
//
//  Created by ms k on 2023/09/22.
//

import UIKit
import FirebaseCore // 솔직히 뭔지 모름
import FirebaseAuth // firebase 로그인기능 활성화
import GoogleSignIn // google 로그인기능 활성화


class LoginViewController: UIViewController, LoginCheck {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var kakaoButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // 기존에 로그인한 경우에 바로 페이지 이동하기
        if Auth.auth().currentUser != nil{
            print("로그인 됨", Auth.auth().currentUser?.uid as Any)
            let Tabbar = storyboard?.instantiateViewController(identifier: Constants.storyboard.Tabbar) as? UITabBarController
            print("go to tabbar")
            view.window?.rootViewController = Tabbar
        }else{
            print("로그인 안됨", Auth.auth().currentUser?.uid as Any)
        }
        checkLoginGoogleStatus()
        
        if isLogin() {
            // 로그인된 상태일 때의 작업 수행
            transitionToHome()
        } else {
            // 로그인되지 않은 상태일 때의 작업 수행
            // 예: 로그인 화면 표시 또는 아무 작업도 하지 않음
        }
        
        // 키보드 화면가림 해결 함수
        setKeyboardEvent()

    }
    
    // keyboard 빈화면 클릭시 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    // 키보드가 생성될 때 메모리에 상주하는 옵저버와 없어질때 옵저버 두개 필요함
    func setKeyboardEvent(){
        // 키보드가 생겼을 때
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // 키보드가 없어졌을 때
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisApper(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        // 키보드가 생겼을 때
        @objc func keyboardWillAppear(_ sender: NotificationCenter){
            self.view.frame.origin.y = -100 // 250만큼 화면을 올려줌(누적시키면 안됨)
        }
        // 키보드가 없어졌을 때
        @objc func keyboardWillDisApper(_ sender: NotificationCenter){
            self.view.frame.origin.y = 0 // 0으로 다시 보내서 다시 원상복구
        }

    


 
    // 이메일 로그인
    @IBAction func btnEmail(_ sender: UIButton) {
        let id = tfEmail.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let pw = tfPassword.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        // Firebase Auth Login
        Auth.auth().signIn(withEmail: id, password: pw) {authResult, error in
            if authResult != nil {
                print("로그인 성공")
                let resultAlert = UIAlertController(title: "로그인 성공", message: "환영합니다!", preferredStyle: .actionSheet)
                let onAction = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                    // 로그인 성공시 페이지 이동하는 함수
                    self.transitionToHome()
                    self.navigationController?.popViewController(animated: true)
                })
                resultAlert.addAction(onAction)
                self.present(resultAlert, animated: true)
            } else {
                let resultAlert = UIAlertController(title: "로그인 실패", message: "아이디와 비밀번호를 \n 다시 확인해주세요.", preferredStyle: .actionSheet)
                let onAction = UIAlertAction(title: "OK", style: .default)
                resultAlert.addAction(onAction)
                self.present(resultAlert, animated: true)

                print("아이디와 비밀번호를 다시 확인해주세요.")
                print(error.debugDescription)
            }
        }
    }
    
    // 구글 로그인
    @IBAction func btnGoogle(_ sender: UIButton) {
        
    }
    
    // 카카오 로그인
    @IBAction func btnKakao(_ sender: UIButton) {
    }
    
    // 회원가입
    @IBAction func btnSignup(_ sender: UIButton) {
    }
    
    @IBAction func TestButton(_ sender: UIButton) {
        self.transitionToHome()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    // 로그인 성공시 페이지 이동하는 함수
    func transitionToHome(){
        print("1")
        let Tabbar = storyboard?.instantiateViewController(identifier: Constants.storyboard.Tabbar) as? UITabBarController
        print("go to tabbar")
        view.window?.rootViewController = Tabbar
    }

    
} // LoginViewController

extension LoginViewController {
    // 기존 로그인 상태 확인
    func checkLoginGoogleStatus() {
        GIDSignIn.sharedInstance.restorePreviousSignIn() { user, error in
            if error != nil || user == nil {
                // 비로그인 상태
                print("No Sign IN")
            } else {
                // 로그인 상태
                guard let user = user else { return }
                guard let profile = user.profile else { return }
                // 유저 데이터 로드
                self.loadUserData(profile)
            }
        }
    }
    
    //        // 스토리보드 이름과 뷰 컨트롤러의 Storyboard ID 지정
    //        let storyboard = UIStoryboard(name: "MainPageSB", bundle: nil) // 여기서 "Main"은 스토리보드의 이름입니다.
    //        let viewController = storyboard.instantiateViewController(withIdentifier: "SideSB") // "YourViewControllerStoryboardID"에 뷰 컨트롤러의 실제 Storyboard ID를 사용합니다.
    //
    //        // 뷰 컨트롤러 표시
    //        self.navigationController?.pushViewController(viewController, animated: true)

    
    // 구글 로그인
    func googleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Google Sign In configration object 생성
        let config = GIDConfiguration(clientID: clientID)

        // Sign In기능을 활성화하고 그 화면을 self에 띄우는 과정
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else{
                // 로그인 실패시
                let popup = UIAlertController(title: "로그인 실패", message: "다시 로그인해주세요", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default)
                popup.addAction(action)
                self.present(popup, animated: true)
                return
            }
            // 로그인 성공시
            guard let user = result?.user else { return }
            guard let profile = user.profile else { return }
            // 유저 데이터 로드
            self.loadUserData(profile)

            // 인증을 해도 계정은 따로 등록을 해주어야 한다.
            // 구글 인증 토큰 받아서 -> 사용자 정보 토큰 생성 -> 파이어베이스 인증에 등록
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                // ...
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            // 파베 로그인되는 부분
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    

    
    
    // 유저 데이터 전달
    func loadUserData(_ profile: GIDProfileData) {
        let emailAddress = profile.email
        let fullName = profile.name
        let profilePicUrl = profile.imageURL(withDimension: 180)
        
        if let profilePicUrl = profile.imageURL(withDimension: 180) {
            // URL에서 이미지 다운로드
            if let data = try? Data(contentsOf: profilePicUrl) {
                if let image = UIImage(data: data) {
                    // 이미지를 성공적으로 다운로드 및 변환한 경우
                    DataLoad.profile = image
                    DataLoad.name = fullName
                    DataLoad.email = emailAddress
                }
            }
        }
        self.transitionToHome()
    }
    
   
    
    

    // 마이페이지 이동
//    func moveMyPage(_ data:UserData){
//        let board = UIStoryboard(name: "MyPage", bundle: nil)
//        guard let nextVC = board.instantiateViewController(withIdentifier: "MyPage") as? SdViewController else { return }
//        nextVC.userData = data
//        nextVC.modalTransitionStyle = .coverVertical
//        nextVC.modalPresentationStyle = .overFullScreen
//        self.present(nextVC, animated: true)
//    }
   
}

extension LoginViewController {
    @IBAction func clickGoogleLogin(_ sender: UIButton){
        googleLogin()
    }
}

protocol LoginCheck {
    func isLogin() -> Bool
}

extension LoginCheck {
    func isLogin() -> Bool {
        print(Auth.auth().currentUser?.uid != nil ? "DEBUG: 로그인 되어있음" : "DEBUG: 로그인 안되어있음")
        return Auth.auth().currentUser?.uid != nil ? true : false
    }
}
