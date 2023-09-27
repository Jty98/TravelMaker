//
//  PlanAddViewController.swift
//  TravelMaker
//
//  Created by 정태영 on 2023/09/26.
//

import UIKit
import BSImagePicker
import Photos
import FirebaseAuth

struct ImageData {
    var image: UIImage
    var isDeletable: Bool // 이미지 삭제 가능 여부 변수
}


class PlanAddViewController: UIViewController {
    
    @IBOutlet weak var PhotoCollectionView: UICollectionView!
    var selectedImages: [UIImage] = []
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var tfTag: UITextField!
    @IBOutlet weak var tvPlan: UITextView!
    
    // 초기 날짜값을 오늘로 설정하기위해 선언
    private let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 컬렉션 뷰의 스크롤 방향을 수평(horizontal)으로 설정
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        PhotoCollectionView.collectionViewLayout = layout

        PhotoCollectionView.dataSource = self
        PhotoCollectionView.delegate = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 원하는 날짜 형식으로 설정
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        lblDate.text = dateString
        
    }
    
    
    @IBAction func btnUpload(_ sender: UIButton) {
        showImagePicker()
    }
    
    // 데이트피커 띄우기 버튼
    @available(iOS 14.0, *)
    @IBAction func btnDatePicker(_ sender: UIButton) {
        setupDatePicker()
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "확인", style: .default) { (_) in
            let selectedDate = datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // 원하는 날짜 형식으로 설정
            let selectedDateString = dateFormatter.string(from: selectedDate)
            self.lblDate.text = selectedDateString
        }
        alertController.view.addSubview(datePicker)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // 데이트피커 초기설정
    private func setupDatePicker() {
         datePicker.datePickerMode = .date
         datePicker.preferredDatePickerStyle = .wheels
         datePicker.locale = Locale(identifier: "ko-KR")
         
         // 초기 날짜를 오늘 날짜로 설정
         datePicker.date = Date()
         
         // 버튼을 누를 때 데이트피커를 화면에 추가
         datePicker.isHidden = true
         view.addSubview(datePicker)
         
         datePicker.translatesAutoresizingMaskIntoConstraints = false
         datePicker.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
         datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
         datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
         
         // 날짜가 선택되면 라벨에 표시
         datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
     }
     
     @objc private func dateChanged(_ sender: UIDatePicker) {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd" // 원하는 날짜 형식으로 설정
         let selectedDateString = dateFormatter.string(from: sender.date)
         lblDate.text = selectedDateString
     }
     
    
    
    // BSImagePicker 실행
    func showImagePicker() {
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5 // 최대 선택 가능한 이미지 개수
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]

        self.presentImagePicker(imagePicker, select: { (asset) in
            // 이미지를 선택할 때 호출
            self.handleAsset(asset)
        }, deselect: { (asset) in
            // 이미지를 선택 취소할 때 호출
        }, cancel: { (assets) in
            // 이미지 선택을 취소할 때 호출
        }, finish: { (assets) in
            // 이미지 선택이 완료될 때 호출
            self.PhotoCollectionView.reloadData() // 컬렉션 뷰를 다시 로드하여 선택한 이미지를 표시
        }, completion: nil)
    }

    // 이미지 처리
    func handleAsset(_ asset: PHAsset) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true

        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: requestOptions, resultHandler: { image, info in
            if let image = image {
                // 이미지 선택 후 작업
                self.selectedImages.append(image) // 이미지를 배열에 추가
            }
        })
    }



    @objc func deleteButtonTapped(_ sender: UIButton) {
        // 삭제 버튼이 속한 셀을 찾아내기
        if let cell = sender.superview as? UICollectionViewCell,
           let indexPath = PhotoCollectionView.indexPath(for: cell) {
            
            // 선택한 이미지 데이터를 배열에서 제거
            selectedImages.remove(at: indexPath.item)
            
            // 컬렉션 뷰 업데이트
            PhotoCollectionView.reloadData()
        }
    }

    // 플랜 저장하기
    @IBAction func btnAddPlan(_ sender: UIButton) {
        let date = lblDate.text ?? ""
        let tag = tfTag.text ?? ""
        let plan = tvPlan.text ?? ""
        
        if let currentUser = Auth.auth().currentUser {
            let currentUserUID = currentUser.uid
            
            let addModel = PlanInsertModel()
            let insert = addModel.insertItems(uid: currentUserUID, taglist: tag, selectedImages: selectedImages, date: date)
            
            if insert == true {
                // Firebase 작업이 완료될 때까지 2초 동안 대기
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    let resultAlert = UIAlertController(title: "완료", message: "추가 되었습니다.", preferredStyle: .actionSheet)
                    let onAction = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                        self.navigationController?.popViewController(animated: true)
                    })
                    resultAlert.addAction(onAction)
                    self.present(resultAlert, animated: true)
                }
            } else {
                let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 되었습니다.", preferredStyle: .alert)
                let onAction = UIAlertAction(title: "OK", style: .default)
                resultAlert.addAction(onAction)
                present(resultAlert, animated: true)
            }

            }
    }
} // PlanAddViewController

extension PlanAddViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Cell 갯수(Section)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
//     Cell 구성 (cellfor)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell // Cell 디자인 따로 한다고 알려주기

        
        cell.imgPhoto.image = selectedImages[indexPath.row]
        
        // 이미지 데이터에서 이미지를 가져와서 설정
        let deleteButton = cell.btnDelete
//        deleteButton!.setTitle("X", for: .normal)
//        deleteButton!.tintColor = .red
//        deleteButton!.frame = CGRect(x: cell.bounds.width - 20, y: 0, width: 20, height: 20)
        deleteButton!.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        cell.addSubview(deleteButton!)
        
        return cell
    }
}
    
    extension PlanAddViewController: UICollectionViewDelegateFlowLayout {
        
        // 위아래 간격(min)
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
        
        // 좌우간격(minimum)
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
        
        // Cell Size-옆 라인을 고려해서 설정(sizefor)
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.width / 3 - 1 // 좌우간격 한칸씩 띄어서 -1
            let size = CGSize(width: width, height: width)
            return size
        }
    }



