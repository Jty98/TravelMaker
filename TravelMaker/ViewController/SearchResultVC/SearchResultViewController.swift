//
//  SearchResultViewController.swift
//  TravelMaker
//
//  Created by ms k on 2023/09/22.
//

import UIKit

class SearchResultViewController: UIViewController {

    @IBOutlet weak var tvResult1: UITextView!
    @IBOutlet weak var tvResult2: UITextView!
    @IBOutlet weak var tvResult3: UITextView!
    @IBOutlet weak var tvResult4: UITextView!
    @IBOutlet weak var tvResult5: UITextView!
    
    
    var receivedResult1 = ""
    var receivedResult2 = ""
    var receivedResult3 = ""
    var receivedResult4 = ""
    var receivedResult5 = ""
   
//    var listResult: [DBModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resultQuery = ResultQueryModel()
//        resultQuery.delegate = self
        resultQuery.downloadItems()
        // Do any additional setup after loading the view.
        
    }
    
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "sgResultView"{
//        let resultView = segue.destination as! ResultViewController
//            
//            resultView.receivedContent = tfSearch.text ?? "제주도 관광"
//        }
//    }
    


}   // SearchResultViewController




