//
//  MyImage.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import Foundation
import UIKit

class MyImage {
    static let shared = MyImage()
    
    private init() {}
    
    let icSearch: UIImage = UIImage(named: "ic_search")!
    let icDashboard: UIImage = UIImage(named: "ic_dashboard")!
    let icPerson: UIImage = UIImage(named: "ic_profile")!
    let icBack: UIImage = UIImage(named: "ic_back")!
}
