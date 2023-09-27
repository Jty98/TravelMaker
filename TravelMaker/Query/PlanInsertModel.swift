//
//  PlanInsertModel.swift
//  TravelMaker
//
//  Created by 정태영 on 2023/09/26.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit


class PlanInsertModel {
    let db = Firestore.firestore()

    func insertItems(uid: String, taglist: String, selectedImages: [UIImage], date: String) -> Bool {
        var status: Bool = true
        let group = DispatchGroup() // 여러 개의 이미지 업로드 작업을 추적하기 위한 DispatchGroup
        var imageUrls: [String] = [] // 이미지 URL을 저장할 배열

        for image in selectedImages {
            group.enter() // DispatchGroup에 진입을 선언

            // 이미지를 데이터로 변환
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                status = false
                group.leave() // 이미지 데이터를 가져오지 못한 경우 DispatchGroup에서 빠져나옴
                continue
            }

            let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpeg")

            storageRef.putData(imageData, metadata: nil) { (_, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    status = false
                } else {
                    // 이미지가 성공적으로 업로드되면 다운로드 URL을 얻어와 배열에 추가
                    storageRef.downloadURL { (url, error) in
                        if let imageUrl = url?.absoluteString {
                            imageUrls.append(imageUrl)
                        }

                        group.leave() // DispatchGroup에서 빠져나옴
                    }
                }
            }
        }

        group.wait() // 모든 이미지 업로드 작업이 완료될 때까지 대기

        if status {
            // 이미지 URL들을 `,`로 구분하여 문자열로 만듭니다.
            let combinedImageUrl = imageUrls.joined(separator: ",")

            // Firestore에 데이터 추가
            let documentRef = db.collection("planlist").document()
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                transaction.setData([
                    "uid": uid,
                    "taglist": taglist,
                    "imageurl": combinedImageUrl, // 이미지 URL들을 문자열로 저장
                    "date": date // Date를 Timestamp로 변환하여 저장
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

        return status
    }
}
