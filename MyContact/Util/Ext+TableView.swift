//
//  Ext+TableView.swift
//  MyContact
//
//  Created by Low Jung Xuan on 09/08/2024.
//

import Foundation
import UIKit

extension UITableView {
    func sizeHeaderToFit() {
        guard let headerView = tableHeaderView else { return }
        
        let newHeight = headerView.systemLayoutSizeFitting(CGSize(width: frame.width, height: .greatestFiniteMagnitude), withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        var frame = headerView.frame
        
        // avoids infinite loop!
        if newHeight.height != frame.height {
            frame.size.height = newHeight.height
            headerView.frame = frame
            tableHeaderView = headerView
        }
    }
}
