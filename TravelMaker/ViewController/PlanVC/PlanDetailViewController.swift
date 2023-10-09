//
//  PlanDetailViewController.swift
//  TravelMaker
//
//  Created by 정태영 on 2023/09/26.
//

import UIKit

class PlanDetailViewController: UIViewController {
    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var tvPlan: UITextView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
//    var updatePhoto: UIImage? = UIImage(systemName: "photo.artframe") // 수정된 이미지 넣기용
    
    // 받아올 변수들
    var receiveDocumentId = ""
    var receivePlan = ""
    var receiveDate: String?
    var receiveTag = ""

    var receivePhotoList: [String] = [] // 여러개의 사진을 받아오기
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController.numberOfPages = receivePhotoList.count  // 페이지 수를 이미지 URL 배열의 항목 수로 설정
        
//        print("*** receivePhotoList.count *** = \(receivePhotoList.count)")
        pageController.currentPage = 0                 // 초기 페이지 설정
        pageController.pageIndicatorTintColor = UIColor.white
        pageController.currentPageIndicatorTintColor = UIColor.gray
                
        // 첫 이미지를 표시해주기
        if let firstImageURL = URL(string: receivePhotoList.first ?? "") {
            imgPhoto?.sd_setImage(with: firstImageURL) { (image, error, cacheType, url) in
                if error != nil {
                    // 이미지 로딩 중 오류가 발생한 경우 처리
                    DispatchQueue.main.async {
                        self.imgPhoto?.image = UIImage(systemName: "photo.artframe")
                    }
                }
            }
        } else {
            // URL을 생성할 수 없는 경우에 대한 처리
        }

        lblTag.text = " \(receiveTag)"
        lblDate.text = receiveDate
        tvPlan.text = receivePlan
        
        // lblTag 테두리 설정
        lblTag.layer.borderWidth = 1.0
        lblTag.layer.cornerRadius = 5.0
        lblTag.layer.borderColor = UIColor.black.cgColor

        // tvPlan 테두리 설정
        tvPlan.layer.borderWidth = 1.0
        tvPlan.layer.cornerRadius = 5.0
        tvPlan.layer.borderColor = UIColor.black.cgColor

        
    } // ViewDidLoad
    
    @IBAction func pageChange(_ sender: UIPageControl) {
        // 이미지 URL(공백제거 해줘야함)
        let imageURLString = receivePhotoList[pageController.currentPage].trimmingCharacters(in: .whitespaces)
        if let imageURL = URL(string: imageURLString) {
            // SDWebImage를 사용하여 이미지 다운로드 및 표시
            imgPhoto.sd_setImage(with: imageURL) { (image, error, cacheType, url) in
                if error != nil {
                    // 이미지 로딩 중 오류가 발생한 경우 처리
                    DispatchQueue.main.async {
                        self.imgPhoto?.image = UIImage(systemName: "photo.artframe")
                    }
                }
            }
        }
        makeSingleTouch()
    }
    

    func makeSingleTouch(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(PlanDetailViewController.respondToSwipeGesture(_ :)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(PlanDetailViewController.respondToSwipeGesture(_ :)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)

    }
    
    
    // singleTouch를 objectC로 정의
    @objc func respondToSwipeGesture(_ gestuere: UIGestureRecognizer){
        // 애매한 방향으로 swipe했을 대 nil이 들어가서 nil체크해야됨
        if let swipeGesture = gestuere as? UISwipeGestureRecognizer{
            // 지우고 시작하기위해 0번부터 넣어줌
            
            // 이미지 URL(공백제거 해줘야함)
            let imageURLString = receivePhotoList[pageController.currentPage].trimmingCharacters(in: .whitespaces)
            if let imageURL = URL(string: imageURLString) {
                // SDWebImage를 사용하여 이미지 다운로드 및 표시
                imgPhoto.sd_setImage(with: imageURL) { (image, error, cacheType, url) in
                    if error != nil {
                        // 이미지 로딩 중 오류가 발생한 경우 처리
                        DispatchQueue.main.async {
                            self.imgPhoto?.image = UIImage(systemName: "photo.artframe")
                        }
                    }
                }
            }

            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.left:
                pageController.currentPage -= 1
                // SDWebImage를 사용하여 이미지 다운로드 및 표시
                if let imageURL = URL(string: imageURLString) {
                    // SDWebImage를 사용하여 이미지 다운로드 및 표시
                    imgPhoto.sd_setImage(with: imageURL) { (image, error, cacheType, url) in
                        if error != nil {
                            // 이미지 로딩 중 오류가 발생한 경우 처리
                            DispatchQueue.main.async {
                                self.imgPhoto?.image = UIImage(systemName: "photo.artframe")
                            }
                        }
                    }
                }

            case UISwipeGestureRecognizer.Direction.right:
                pageController.currentPage += 1
                // SDWebImage를 사용하여 이미지 다운로드 및 표시
                if let imageURL = URL(string: imageURLString) {
                    // SDWebImage를 사용하여 이미지 다운로드 및 표시
                    imgPhoto.sd_setImage(with: imageURL) { (image, error, cacheType, url) in
                        if error != nil {
                            // 이미지 로딩 중 오류가 발생한 경우 처리
                            DispatchQueue.main.async {
                                self.imgPhoto?.image = UIImage(systemName: "photo.artframe")
                            }
                        }
                    }
                }
            default: break
            }
        }
    }

    


} // PlanDetailViewController
