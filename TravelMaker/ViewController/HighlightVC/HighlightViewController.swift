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
