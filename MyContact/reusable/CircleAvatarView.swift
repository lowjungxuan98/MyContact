//
//  CircleAvatarView.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import UIKit

class CircleAvatarView: UIView {
    
    private let label: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(label)
        backgroundColor = ColorPalette.shared.blue_0077B6
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width / 2
    }
    
    func configure(with text: String, font: UIFont) {
        label.text = text
        label.font = font
    }
}

