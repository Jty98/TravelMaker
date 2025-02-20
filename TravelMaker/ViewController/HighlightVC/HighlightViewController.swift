//
//  LensViewController.swift
//  TravelMaker
//
//  Created by ms k on 2023/09/22.
//

import UIKit
import Firebase // 파베 데이터베이스
import FirebaseStorage // 파베 이미지저장소
import FirebaseAuth // 파베 로그인
import SDWebImage // 캐싱해서 빠른 이미


class HighlightViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var highlightListData : [HighlightSelectModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        readValues()
    }
    func readValues(){
        let QueryModel = HighlightQueryModel()
        QueryModel.delegate = self
        QueryModel.downloadItems()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()

    }
    
    // SideMenu 불러오는 방식으로 모든 페이지에 똑같이 버튼 만들고 붙여넣으면 됨
    @IBAction func sideMenuAction(_ sender: UIBarButtonItem) {
        // 스토리보드 이름과 뷰 컨트롤러의 Storyboard ID 지정
        let storyboard = UIStoryboard(name: "MainPageSB", bundle: nil) // 스토리보드 파일 이름
        let viewController = storyboard.instantiateViewController(withIdentifier: "SideSB") // 스토리보드 식별자 이름
        present(viewController, animated: true, completion: nil)

    }
    
    
    
        
        
    


}
extension HighlightViewController : HighlightQueryModelProtocol{
    func itemDownloaded(items: [HighlightSelectModel]){
        highlightListData = items
        self.collectionView.reloadData()
    }
}
extension HighlightViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    //cell갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return highlightListData.count
    }
    
    //cell구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CollectionViewCell
        
        cell.imgView.image = UIImage(named : highlightListData[indexPath.row].imageurl)
        cell.backgroundColor = .black
        let PhotoList = highlightListData[indexPath.row].imageurl.split(separator: ",").map { String($0) }
        let imgView = cell.imgView
        
        if let imageURL = URL(string: PhotoList[0]) {
            imgView?.sd_setImage(with: imageURL) { (image, error, cacheType, url) in
                if error != nil {
                    // 이미지 로딩 중 오류가 발생한 경우 처리
                    DispatchQueue.main.async {
                        imgView?.image = UIImage(systemName: "photo.artframe")
                    }
                }
            }
        } else {
            // URL을 생성할 수 없는 경우에 대한 처리
        }
        
        return cell
    }
    
    //clickEvent
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(highlightListData[indexPath.row])
    }
    
    // prepare넘기기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "HDetailSG"{
            let cell = sender as! UICollectionViewCell   // 셀인식
            let indexPath = self.collectionView.indexPath(for: cell)  // 몇번째 셀 인식
            
            let detailView = segue.destination as! HDetailViewController
            
            detailView.receiveDocumentId = highlightListData[indexPath!.row].documentId
            
            let PhotoList = highlightListData[indexPath!.row].imageurl.split(separator: ",").map { String($0) }
            
            print(" *** PhotoList *** = \(PhotoList)")
            detailView.receivePhotoList = PhotoList
            detailView.receivePlan = highlightListData[indexPath!.row].plan
            detailView.receiveTag = highlightListData[indexPath!.row].taglist
            
            //            let dateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "yyyy-MM-dd" // 원하는 날짜 형식으로 설정
            //            // 날짜를 문자열로 변환
            //            let date = planListData[indexPath!.row].date
            //            detailView.receiveDate = dateFormatter.string(from: date)
            detailView.receiveDate = highlightListData[indexPath!.row].date
            
        }
        
        
        
    }
}


extension HighlightViewController : UICollectionViewDelegateFlowLayout{
    //좌우 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    //위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    //cellSize(옆 라인을 고려하여 설정)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 1
        let size = CGSize(width: width, height: width)
        return size
    }
}
