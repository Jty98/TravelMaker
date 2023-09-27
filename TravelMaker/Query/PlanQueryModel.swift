//
//  PlanModel.swift
//  TravelMaker
//
//  Created by 정태영 on 2023/09/26.
//

import Foundation
import Firebase

protocol QueryModelProtocol {
    func itemDownloaded(items: [SelectModel])
}

class PlanQueryModel {
    var delegate: QueryModelProtocol!
    let db = Firestore.firestore()
    
    func downloadItems() {
        var locations: [SelectModel] = []
        
        if let currentUser = Auth.auth().currentUser {
            let currentUserUID = currentUser.uid
            
            db.collection("planlist")
                .whereField("uid", isEqualTo: currentUserUID) // 사용자 고유 UID와 일치하는 항목만 가져오기
                .order(by: "date") // 이 조건 줄거면 firebase database의 색인 조건 추가해줘야함 (에러 떴을때 뜨는 url 주소창에 치면 적용됨)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        print("Data is downloaded")
                        for document in querySnapshot!.documents {
                            //                            let timestamp = document.data()["date"] as? Timestamp
                            //                            let date = timestamp?.dateValue() ?? Date()
                            
                            // 필터링을 여기서 수행
                            //                            if let imageUrls = document.data()["imageurl"] as? [String],
                            //                               let taglist = document.data()["taglist"] as? [String],
                            //                               imageUrls.contains("//"),
                            //                               taglist.contains("#") {
                            //                                let query = FirebaseModel(documentId: document.documentID,
                            //                                                          uid: currentUserUID,
                            //                                                          taglist: taglist,
                            //                                                          imageurl: imageUrls,
                            //                                                          date: date)
                            let query = SelectModel(documentId: document.documentID,
                                                    uid: currentUserUID,
                                                    taglist: document.data()["taglist"] as! String,
                                                    imageurl: document.data()["imageurl"] as! String,
                                                    plan: document.data()["plan"] as! String,
                                                    date: document.data()["date"] as! String)
                            
                            locations.append(query)
                            
                            // 가져온 정보를 출력
                            print("Document ID: \(document.documentID)")
                            //                                print("Date: \(date)")
                            //                                print("Image URLs: \(imageUrls)")
                            //                                print("Tag List: \(taglist)")
                            
                            
                            
                            print(currentUserUID)
                        }
                        DispatchQueue.main.async {
                            self.delegate.itemDownloaded(items: locations)
                        }
                    }
                }
        }
    }
}

