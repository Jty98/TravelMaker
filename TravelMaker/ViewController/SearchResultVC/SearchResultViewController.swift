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
    
    var receiveResultList: [String] = []
    var receivedResult1 = ""
    var receivedResult2 = ""
    var receivedResult3 = ""
    var receivedResult4 = ""
    var receivedResult5 = ""
   
//    var listResult: [DBModel] = []
    var message = Message()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("resultPage : \(Message.result1)")
//        tvResult1.text = Message.result1
        initResult()
//        let resultQuery = ResultQueryModel()
//        resultQuery.delegate = self
//        resultQuery.downloadItems()
        // Do any additional setup after loading the view.
        
    }
    
    func initResult(){
        tvResult1.text = Message.result1
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




