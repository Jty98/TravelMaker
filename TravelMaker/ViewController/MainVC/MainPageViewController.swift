//
//  MainViewController.swift
//  TravelMaker
//
//  Created by ms k on 2023/09/22.
//

import UIKit
import FirebaseAuth

class MainPageViewController: UIViewController {

    @IBOutlet weak var SearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SearchBar.layer.borderColor = UIColor.green.cgColor // 테두리 색상
        SearchBar.layer.borderWidth = 1.0
    }
    
    

   

} // MainPageViewController
