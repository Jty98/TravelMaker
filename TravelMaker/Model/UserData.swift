//
//  UserData.swift
//  TravelMaker
//
//  Created by 정태영 on 2023/09/25.
//

import Foundation
import UIKit

struct UserData{
    let profile: UIImage
    let name: String
    let email: String
}

struct DataLoad{
    static var profile: UIImage?
    static var name: String = ""
    static var email: String = ""
}
