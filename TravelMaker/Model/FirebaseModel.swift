//
//  FirebaseModel.swift
//  TravelMaker
//
//  Created by 정태영 on 2023/09/25.
//

import Foundation

struct FirebaseModel {
    var documentId: String // plan의 고유한 documentId 필드
    var uid: String // 사용자 고유의 UID를 저장할 필드
//    var taglist: [String] // 태그들을 담을 리스트
//    var imageurl: [String] // 이미지를 담을 리스트
    var taglist: String // 태그들을 담을 리스트
    var imageurl: String // 이미지를 담을 리스트
    var date: Date // 날짜를 담을 필드
    
    init(documentId: String, uid: String, taglist: String, imageurl: String, date: Date) {
        self.documentId = documentId
        self.uid = uid
        self.taglist = taglist
        self.imageurl = imageurl
        self.date = date
    }
}
