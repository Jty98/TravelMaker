//
//  SignUpModel.swift
//  TravelMaker
//
//  Created by 정태영 on 2023/09/25.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class FirebaseSignUpModel{
    let db = Firestore.firestore()
    var status: Bool = true
    
    func signUpUser(userId: String, email: String, password: String, name: String, gender: String, age: String, MBTI: String) -> Bool{
        
        db.collection("user").addDocument(data: [
            "id": userId,
            "email": email,
            "password": password,
            "name": name,
            "gender": gender,
            "age": age,
            "MBTI": MBTI
            ]) {error in
                if error != nil{
                    self.status = false
                }else{
                    self.status = true
                }
            }
        return status
    }
    
}
