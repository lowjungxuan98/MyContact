//
//  Ext+Date.swift
//  MyContact
//
//  Created by Low Jung Xuan on 09/08/2024.
//

import Foundation

extension Date {
    func toString(format: String = "d/M/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
