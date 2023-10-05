//
//  MainViewController.swift
//  TravelMaker
//
//  Created by ms k on 2023/09/22.
//

import UIKit
import FirebaseAuth

class MainPageViewController: UIViewController {

    @IBOutlet weak var tfSearch: UITextField!
    
    
    @IBOutlet weak var tvWeatherView: UITextView!
    var listResult: [DBModel] = []
    var resultText: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func sendContent(url: String){
        guard let myUrl = URL(string: url) else {return}
        let myRequest = URLRequest(url: myUrl)
    }

    @IBAction func btnSearch(_ sender: UIButton) {
//        let searchContent = tfSearch.text ?? "제주도 관광"
//        guard let searchContent = tfSearch.text else {return}
        
        tvWeatherView.text = ""
        
        let searchContent = tfSearch.text!
        let tfContent = searchContent
        sendContent(url: tfContent)
        
        let resultQuery = ResultQueryModel()
        resultQuery.delegate = self
        resultQuery.searchUrl(content: tfContent)
        resultQuery.downloadItems()
    

    
        // 다음 화면으로 이동
//        let board = UIStoryboard(name: "SearchResultSB", bundle: nil)
//        guard let nextVC = board.instantiateViewController(withIdentifier: "SearchResultView") as? SearchResultViewController else { return }
//        nextVC.modalTransitionStyle = .coverVertical
//        nextVC.modalPresentationStyle = .overFullScreen
//        UIApplication.shared.windows.first?.rootViewController = nextVC
        
//        let Tabbar = storyboard?.instantiateViewController(identifier: Constants.storyboard.resultTabbar) as? UITabBarController
//        print("go to tabbar")
//        view.window?.rootViewController = Tabbar


    }
    

    // 빈공간 클릭시 키보드 사라지게 하기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sgResultView"{
//        let resultView = segue.destination as! SearchResultViewController
////
//            resultView.receivedResult1 = listResult.
//            
        }
    }
    

//    // API Key 접근 코드
//    private var apiKey: String {
//        get {
//            // 생성한 .plist 파일 경로 불러오기
//            guard let filePath = Bundle.main.path(forResource: "Jin_weatherAPI_Key", ofType: "plist") else {
//                fatalError("Couldn't find file 'Jin_weatherAPI_Key.plist'.")
//            }
//            
//            // .plist를 딕셔너리로 받아오기
//            let plist = NSDictionary(contentsOfFile: filePath)
//            
//            // 딕셔너리에서 값 찾기
//            guard let value = plist?.object(forKey: "OPENWEATHERMAP_KEY") as? String else {
//                fatalError("Couldn't find key 'OPENWEATHERMAP_KEY' in 'Jin_weatherAPI_Key.plist'.")
//            }
//            return value
//        }
//    }


} // MainPageViewController

extension MainPageViewController: ResultQueryProtocol{
    func itemDownloaded(items: [DBModel]) {
        listResult = items
        print("items : \(items)")
        print("listResult : \(listResult)")
        let resultText = listResult.map { "\($0.result1), \($0.result2), \($0.result3), \($0.result4), \($0.result5)" }.joined(separator: "\n")
        print("resultText : \(resultText)")
        print("type of listResult : \(type(of: listResult))")
        print("type of resultText : \(type(of: resultText))")
        Message.result1 = resultText

        // 쉼표를 기준으로 문자열을 분할
        let resultArray = resultText.components(separatedBy: ", ")
        
        // 각 부분을 textView에 추가
        for item in resultArray {
            tvWeatherView.text += item + "\n"
        }
        
//        tvWeatherView.text = resultText
//                tvResult1.text = resultText
    }
//    func itemDownloaded(items: [DBModel]) {
//        listResult = items
//        print(listResult)
////        tvResult1.text = listResult
//    }
    
    
}
