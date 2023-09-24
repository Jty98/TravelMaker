//
//  LoginViewController.swift
//  TravelMaker
//
//  Created by ms k on 2023/09/22.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnLogin(_ sender: UIButton) {
        transitionToHome()
        
    }
    func transitionToHome(){
        print("1")
        let Tabbar = storyboard?.instantiateViewController(identifier: Constants.storyboard.Tabbar) as? UITabBarController
        print("go to tabbar")
        view.window?.rootViewController = Tabbar
    }
    
}
