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


class LoginViewController: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var kakaoButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

//        // 버튼 테두리 설정
//        googleButton.layer.borderWidth = 1.0 // 테두리 두께
//        googleButton.layer.borderColor = UIColor.gray.cgColor // 테두리 색상
//        googleButton.layer.cornerRadius = 10.0 // 테두리 둥글기
//        emailButton.layer.borderWidth = 1.0 // 테두리 두께
//        emailButton.layer.borderColor = UIColor.gray.cgColor // 테두리 색상
//        emailButton.layer.cornerRadius = 10.0 // 테두리 둥글기
//        kakaoButton.layer.borderWidth = 1.0 // 테두리 두께
//        kakaoButton.layer.borderColor = UIColor.gray.cgColor // 테두리 색상
//        kakaoButton.layer.cornerRadius = 10.0 // 테두리 둥글기

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

//        DataLoad.profile1 = emailAddress
//        DataLoad.name1 = profile.name
        
        print("emailAddress = ", emailAddress)
        print("fullName = ", fullName)
        print("profilePicUrl = ", profilePicUrl)

        // 이미지 다운로드
        if let profilePicUrl = profilePicUrl {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: profilePicUrl) {
                    if let image = UIImage(data: data) {
                        // UI는 main thread에서만 접근 가능
                        DispatchQueue.main.async {
                            let userData = UserData(profile: image, name: fullName, email: emailAddress)
//                            let board = UIStoryboard(name: "MyPage", bundle: nil)
//                            // 데이터를 전달할 뷰 컨트롤러에 설정
//                            guard let nextVC = board.instantiateViewController(withIdentifier: "MyPage") as? SdViewController else { return }
                            func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                                   if segue.identifier == "SideMenuSegue" {
                                       if let sideMenuViewController = segue.destination as? SdViewController {
                                           // 데이터를 설정
                                           sideMenuViewController.userData = userData
                                       }
                                   }
                               }
                            
//                            sideMenuViewController.userData = userData

                            self.transitionToHome()
                        }
                    }
                }
            }
        }
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

