//
//  HighlightQueryModel.swift
//  TravelMaker
//
//  Created by ms k on 2023/09/27.
//


import Foundation
import Firebase

protocol HighlightQueryModelProtocol {
    func itemDownloaded(items: [HighlightSelectModel])
}

class HighlightQueryModel {
    var delegate: HighlightQueryModelProtocol!
    let db = Firestore.firestore()
    
    func downloadItems() {
        var locations: [HighlightSelectModel] = []
            
            db.collection("planlist")
            .order(by: "date", descending: true) // 이 조건 줄거면 firebase database의 색인 조건 추가해줘야함 (에러 떴을때 뜨는 url 주소창에 치면 적용됨)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        print("Data is downloaded")
                        for document in querySnapshot!.documents {
                            let query = HighlightSelectModel(documentId: document.documentID,
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
                            
                            
                            
                            
                        }
                        DispatchQueue.main.async {
                            self.delegate.itemDownloaded(items: locations)
                        }
                    }
                }
        }
    }


