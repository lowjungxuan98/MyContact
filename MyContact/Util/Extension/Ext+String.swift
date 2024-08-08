//
//  Ext+String.swift
//  MyContact
//
//  Created by Low Jung Xuan on 09/08/2024.
//

import Foundation

extension String {
    func toDate(format: String = "d/M/yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
