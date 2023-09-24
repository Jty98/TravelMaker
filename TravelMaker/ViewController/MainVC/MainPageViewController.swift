//
//  MainViewController.swift
//  TravelMaker
//
//  Created by ms k on 2023/09/22.
//

import UIKit
import FirebaseAuth

class MainPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnLogout(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                // 로그아웃 성공한 경우, 이미지를 변경하거나 다른 작업 수행
                
                let resultAlert = UIAlertController(title: "로그아웃", message: "로그아웃 되었습니다", preferredStyle: .actionSheet)
                let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in self.transitionToLogout()})
                resultAlert.addAction(onAction)
                self.present(resultAlert, animated: true)
            } catch {
                // 로그아웃 실패한 경우, 에러 메시지 출력
                print(error.localizedDescription)
            }
        } else {
            // 사용자가 로그인하지 않은 경우
        }
    }
    
    // 로그아웃시 첫화면 이동
    func transitionToLogout(){
        let board = UIStoryboard(name: "Main", bundle: nil)
        guard let nextVC = board.instantiateViewController(withIdentifier: "LoginSB") as? LoginViewController else { return }
    //        nextVC.userData = data
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true)
    }

   

} // MainPageViewController
