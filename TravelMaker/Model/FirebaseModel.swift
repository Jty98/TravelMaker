//
//  FirebaseModel.swift
//  TravelMaker
//
//  Created by 정태영 on 2023/09/25.
//

import Foundation
import UIKit

struct FirebaseModel {
    var documentId: String // plan의 고유한 documentId 필드
    var uid: String // 사용자 고유의 UID를 저장할 필드
    var imageurlList: [UIImage] // 이미지피커에서 선택된 것들을 담을 리스트
    var taglist: String // 태그들을 담을 리스트
    var imageurl: String // 이미지를 select할때 필요한 필드
    var plan: String // plan 담을 필드
    var date: String // 날짜를 담을 필드
    
    init(documentId: String, uid: String, imageurlList: [UIImage], taglist: String, imageurl: String, plan: String, date: String) {
        self.documentId = documentId
        self.uid = uid
        self.imageurlList = imageurlList
        self.taglist = taglist
        self.imageurl = imageurl
        self.plan = plan
        self.date = date
    }
}
