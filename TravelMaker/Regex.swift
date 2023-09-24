//
//  Regex.swift
//  TravelMaker
//
//  Created by 정태영 on 2023/09/24.
//

import Foundation

class regex{
    // 이메일 앞부분 regex
    func isValidId(id: String) -> Bool {
        // 5~20자의 영문 소문자, 숫자와 특수기호(_),(-)만 사용, 공백제외
        let usernameRegex = "^[A-Za-z0-9._-]{5,20}$"
        // NSPredicate는 문자열 일치여부를 검사하기위해 표현식을 제공, SELF MATCHES %@에서 SELF MATCHES는 내가 입력한 부분, %@는 정규식부분이 들어가서 비교해주는 것임
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernamePredicate.evaluate(with: id)
    }
    
    // 도메인 regex
    func isValidDomain(domain: String) -> Bool {
        // 공백을 제외한 XXX.XXX의 도메인 형태를 만족하는 regex
        let domainRegex = "^[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let domainPredicate = NSPredicate(format: "SELF MATCHES %@", domainRegex)
        return domainPredicate.evaluate(with: domain)
    }
    
    // 비밀번호 regex
    func isValidPassword(password: String) -> Bool {
        // 8자리 이상, 영문 소문자, 한개이상의 대문자와 특수문자, 공백제외
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$%^&*()_+])[a-zA-Z0-9!@#$%^&*()_+]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    // 사용자 이름 regex
    func isValidName(name: String) -> Bool {
        // 2~8자리 특수문자제외, 공백제외
        let nameRegex = "^(?=.*[A-Za-z가-힣0-9!@#$%^&*()_+])[A-Za-z가-힣0-9!@#$%^&*()_+]{2,8}$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: name)
    }

}

