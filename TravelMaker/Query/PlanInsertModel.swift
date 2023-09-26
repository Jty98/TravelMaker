//
//  PlanInsertModel.swift
//  TravelMaker
//
//  Created by 정태영 on 2023/09/26.
//

import Foundation
import Firebase
import FirebaseStorage

class PlanInsertModel{
    let db = Firestore.firestore()
    
    func insertItems(uid: String, taglist: [String], imageUrls: [String], date: Date) -> Bool {
        var status: Bool = true

        let group = DispatchGroup() // 여러 개의 이미지 업로드 작업을 추적하기 위한 DispatchGroup

        for imageUrl in imageUrls {
            group.enter() // DispatchGroup에 진입을 선언
//            if let image = imageUrl, let imageData = image.jpegData(compressionQuality: 0.5) {
            // 이미지 URL을 Firebase Storage에 업로드
            if let imageUrl = URL(string: imageUrl) {
                guard let imageData = try? Data(contentsOf: imageUrl) else {
                    status = false
                    continue // 이미지 데이터를 가져오지 못한 경우 다음 이미지로 계속 진행
                }

                let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpeg")

                storageRef.putData(imageData, metadata: nil) { (_, error) in
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                        status = false
                    } else {
                        // 이미지가 성공적으로 업로드되면 Firestore에 데이터 추가
                        let documentRef = self.db.collection("planlist").document()

                        self.db.runTransaction({ (transaction, errorPointer) -> Any? in
                            transaction.setData([
                                "uid": uid,
                                "taglist": taglist,
                                "imageUrls": FieldValue.arrayUnion([imageUrl]), // 이미지 URL 추가
                                "date": Timestamp(date: date) // Date를 Timestamp로 변환하여 저장
                            ], forDocument: documentRef)

                            return nil
                        }) { (_, error) in
                            if let error = error {
                                print("Error adding document: \(error)")
                                status = false
                            } else {
                                print("Document added with ID: \(documentRef.documentID)")
                            }
                        }
                    }
                    group.leave() // DispatchGroup에서 빠져나옴
                }
            } else {
                status = false
                group.leave() // DispatchGroup에서 빠져나옴
            }
        }

        group.wait() // 모든 이미지 업로드 작업이 완료될 때까지 대기

        return status
    }
}

