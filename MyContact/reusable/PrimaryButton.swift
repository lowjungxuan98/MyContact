//
//  PrimaryButton.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import UIKit

class PrimaryButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        backgroundColor = ColorPalette.shared.blue_96D3F2_10
        setTitleColor(ColorPalette.shared.blue_0077B6, for: .normal)
        layer.cornerRadius = 5
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 53).isActive = true
        titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
    }
}
