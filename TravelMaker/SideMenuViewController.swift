//
//  SideViewController.swift
//  TravelMaker
//
//  Created by 정태영 on 2023/09/25.
//

import UIKit
import GoogleSignIn
import FirebaseAuth


class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var imgLoadImage: UIImageView!
    @IBOutlet weak var lblLoadName: UILabel!
    @IBOutlet weak var lblLoadEmail: UILabel!
    
    var userData: UserData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgLoadImage.image = userData?.profile
        lblLoadName.text = userData?.name
        lblLoadEmail.text = userData?.email
//        loadProfile()
    }
        

    
} // SideMenuViewController

extension SideMenuViewController {
    // 프로필 가져오기
    func loadProfile(){
        guard let userData = userData else { return }
        imgLoadImage.image = userData.profile
        lblLoadName.text = userData.name
        lblLoadEmail.text = userData.email
    }
    func logOut(){
        GIDSignIn.sharedInstance.signOut()
        print("Logout")
        
        let board = UIStoryboard(name: "Main", bundle: nil)
        guard let nextVC = board.instantiateViewController(withIdentifier: "LoginSB") as? LoginViewController else { return }
    //        nextVC.userData = data
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true)

        do {
                try Auth.auth().signOut()
               print("로그아웃 성공!")
            } catch let error as NSError {
                print("로그아웃 오류: \(error.localizedDescription)")
                // 로그아웃 중에 오류가 발생했습니다. 오류 처리를 수행하세요.
            }
        
    }
}

extension SideMenuViewController {
    @IBAction func clickLogOut(_ sender: UIButton){
        logOut()
    }
}

