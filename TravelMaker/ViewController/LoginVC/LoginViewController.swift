//
//  LoginViewController.swift
//  TravelMaker
//
//  Created by ms k on 2023/09/22.
//

import UIKit
import FirebaseAuth // firebase 로그인기능 활성화

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
    
    // 로그인 성공시 페이지 이동하는 함수
    func transitionToHome(){
        print("1")
        let Tabbar = storyboard?.instantiateViewController(identifier: Constants.storyboard.Tabbar) as? UITabBarController
        print("go to tabbar")
        view.window?.rootViewController = Tabbar
    }

    
} // LoginViewController

