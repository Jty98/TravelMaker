//
//  HighlightModel.swift
//  TravelMaker
//
//  Created by ms k on 2023/09/27.
//

import Foundation


struct HighlightSelectModel {
    var documentId: String // plan의 고유한 documentId 필드
    
    var taglist: String // 태그들을 담을 리스트
    var imageurl: String // 이미지를 select할때 필요한 필드
    var plan: String // plan 담을 필드
    var date: String // 날짜를 담을 필드

    init(documentId: String, taglist: String, imageurl: String, plan: String, date: String) {
        self.documentId = documentId
        self.taglist = taglist
        self.imageurl = imageurl
        self.plan = plan
        self.date = date
    }
}


