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
        
        // 셀에서 이미지를 표시할 이미지 뷰
        let imageView = cell.imgFirstPhoto

        // 이미지 URL
//        let imageURL = URL(string: planListData[indexPath.row].imageurl[0]) // 대표이미지를 첫번째 저장된 이미지로 지정하기
        let imageURL = URL(string: planListData[indexPath.row].imageurl) // 대표이미지를 첫번째 저장된 이미지로 지정하기

        // SDWebImage 라이브러리를 사용하여 이미지 로딩 및 표시
        imageView?.sd_setImage(with: imageURL) { (image, error, cacheType, url) in
            if error != nil {
                // 이미지 로딩 중 오류가 발생한 경우 처리
                DispatchQueue.main.async {
                    imageView?.image = UIImage(systemName: "photo.artframe")
                }
            }
        }
        // 날짜 처리하고 저장
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: planListData[indexPath.row].date)
        cell.lblDate.text = dateString
        // 리스트에 담긴 태그들을 출력하기위함
//        let tags = planListData[indexPath.row].taglist
//        let tagsString = tags.joined(separator: ", ") // ,를 기준으로 자르기
        cell.lblTagList.text = planListData[indexPath.row].taglist
        
//        print("imageURL = \(imageURL)")
//        print("dateString = \(dateString)")
//        print("tagsString = \(tagsString)")

        
        return cell
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

