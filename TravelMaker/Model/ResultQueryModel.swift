//
//  ResultQueryModel.swift
//  TravelMaker
//
//  Created by JinYeong Lee on 2023/09/27.
//

import Foundation

protocol ResultQueryProtocol{
    func itemDownloaded(items: [DBModel])
}

// json 받은 결과 decoding 해서 결과 보여주는 곳
class ResultQueryModel{
    var delegate: ResultQueryProtocol!
    var urlPath = ""
    
    func searchUrl(url:String) -> String {
        urlPath = url
        return urlPath
    }
    
    func downloadItems(){
        print(urlPath)
        let url: URL = URL(string: urlPath)!
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.parseJSON(data!)
            }
        }
    }
    
    func parseJSON(_ data: Data){
        let decoder = JSONDecoder()
        var locations: [DBModel] = []
        
        do{
            let preresult = try decoder.decode(Result.self, from: data)
            for result in preresult.results{
                let query = DBModel(result1: result.result1, result2: result.result2, result3: result.result3, result4: result.result4, result5: result.result5)
                locations.append(query)
            }       // DB로 만든 모델 데이터 추가.?
            print(preresult.results.count)
        }catch let error{
            print("Fail : \(error.localizedDescription)")
        }
        // A가 프로토콜에 준비시키면 B가 실행해서 결과르 ㄹ프로토콜에 주고 A가 받아온다?
        
        DispatchQueue.main.async {
            self.delegate.itemDownloaded(items: locations)
        }
        
        
    }
    
}

