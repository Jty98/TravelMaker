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
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgLoadImage.image = DataLoad.profile
        lblLoadName.text = DataLoad.name
        lblLoadEmail.text = DataLoad.email

//        loadProfile()
    }
        
    // 데이터를 불러와 UI에 설정하는 함수
//    func loadUserData(_ dataLoad: DataLoad) {
//        if let profilePicUrl = dataLoad.profile1,
//           let fullName = dataLoad.name1,
//           let emailAddress = dataLoad.email1 {
//            DispatchQueue.global().async {
//                if let data = try? Data(contentsOf: profilePicUrl),
//                   let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        // 이미지 뷰에 프로필 이미지 설정
//                        self.imgLoadImage.image = image
//
//                        // 레이블에 이름과 이메일 설정
//                        self.lblLoadName.text = fullName
//                        self.lblLoadEmail.text = emailAddress
//                    }
//                }
//            }
//        }
//    }
    
} // SideMenuViewController

extension SideMenuViewController {
    // 프로필 가져오기
    func loadProfile(){
//        guard let userData = userData else { return }
//        imgLoadImage.image = userData.profile
//        lblLoadName.text = userData.name
//        lblLoadEmail.text = userData.email
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
        
        // firebase 로그아웃
        let firebaseAuth = Auth.auth()
           do {
               try firebaseAuth.signOut()
               self.navigationController?.popToRootViewController(animated: true)
           } catch let signOutError as NSError {
               print ("Error signing out: %@", signOutError)
           }

    }
}

extension SideMenuViewController {
    @IBAction func clickLogOut(_ sender: UIButton){
        logOut()
    }
}

