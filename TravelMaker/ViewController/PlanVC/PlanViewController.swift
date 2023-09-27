//
//  PlanViewController.swift
//  TravelMaker
//
//  Created by ms k on 2023/09/22.
//

import UIKit
import Firebase // 파베 데이터베이스
import FirebaseStorage // 파베 이미지저장소
import FirebaseAuth // 파베 로그인
import SDWebImage // 캐싱해서 빠른 이미지띄우게 해줌


class PlanViewController: UIViewController {
    
    @IBOutlet weak var tvPlanList: UITableView!
    var planListData: [FirebaseModel] = []
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvPlanList.dataSource = self
        tvPlanList.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readValues()
    }
    
    // 정보 불러오기
    func readValues(){
        let QueryModel = PlanQueryModel()
        
        myActivityIndicator.startAnimating()
        myActivityIndicator.isHidden = false // indicator 보이기

        QueryModel.delegate = self
        QueryModel.downloadItems()
        tvPlanList.dataSource = self
        tvPlanList.delegate = self
        tvPlanList.reloadData()

    }
    
    
    // SideMenu 불러오는 방식으로 모든 페이지에 똑같이 버튼 만들고 붙여넣으면 됨
    @IBAction func sideMenuAction(_ sender: UIBarButtonItem) {
        // 스토리보드 이름과 뷰 컨트롤러의 Storyboard ID 지정
        let storyboard = UIStoryboard(name: "MainPageSB", bundle: nil) // 스토리보드 파일 이름
        let viewController = storyboard.instantiateViewController(withIdentifier: "SideSB") // 스토리보드 식별자 이름
        present(viewController, animated: true, completion: nil)

     }
    
    


} // PlanViewController

extension PlanViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       // #warning Incomplete implementation, return the number of sections
       return 1
   }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // #warning Incomplete implementation, return the number of rows
       return planListData.count
   }
    
    // 셀구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as! PlanTableViewCell
        
        // 이미지 URL (,단위로 짤라서 순서대로 넣어서 배열 생성)
        let PhotoList = planListData[indexPath.row].imageurl.split(separator: ",").map { String($0) }
        
        //PhotoList[0] = 대표이미지를 첫번째 저장된 이미지로 지정하기
        // SDWebImage 라이브러리를 사용하여 이미지 로딩 및 표시
        
        // 셀에서 이미지를 표시할 이미지 뷰
        let imageView = cell.imgFirstPhoto
        
        if let imageURL = URL(string: PhotoList[0]) {
            imageView?.sd_setImage(with: imageURL) { (image, error, cacheType, url) in
                if error != nil {
                    // 이미지 로딩 중 오류가 발생한 경우 처리
                    DispatchQueue.main.async {
                        imageView?.image = UIImage(systemName: "photo.artframe")
                    }
                }
            }
        } else {
            // URL을 생성할 수 없는 경우에 대한 처리
        }

        // 날짜 처리하고 저장
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: planListData[indexPath.row].date)
        cell.lblDate.text = dateString
        // 리스트에 담긴 태그들을 출력하기위함
        cell.lblTagList.text = planListData[indexPath.row].taglist
        
        return cell
    }
    
    
    // prepare넘기기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "planDetail"{
            let cell = sender as! UITableViewCell   // 셀인식
            let indexPath = self.tvPlanList.indexPath(for: cell)  // 몇번째 셀 인식
            
            let detailView = segue.destination as! PlanDetailViewController
            
            detailView.receiveDocumentId = planListData[indexPath!.row].documentId
            
            let PhotoList = planListData[indexPath!.row].imageurl.split(separator: ",").map { String($0) }

            print(" *** PhotoList *** = \(PhotoList)")
            detailView.receivePhotoList = PhotoList
            detailView.receivePlan = planListData[indexPath!.row].plan
            detailView.receiveTag = planListData[indexPath!.row].taglist
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // 원하는 날짜 형식으로 설정
            // 날짜를 문자열로 변환
            let date = planListData[indexPath!.row].date
            detailView.receiveDate = dateFormatter.string(from: date)
                
        }
        
        
    }


} // extension Table

extension PlanViewController: QueryModelProtocol{
    func itemDownloaded(items: [FirebaseModel]) {
        planListData = items    // data 넣기
        print("items = \(items)")
        self.tvPlanList.reloadData()
        myActivityIndicator.stopAnimating()
        myActivityIndicator.isHidden = true // indicator 숨기기

    }
}

