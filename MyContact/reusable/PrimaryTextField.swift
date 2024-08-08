//
//  PrimaryTextField.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import UIKit

class PrimaryTextField: UIStackView {
    
    private let label: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.isHidden = true
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    private let hStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = ColorPalette.shared.gray_CCCCCC.cgColor
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.heightAnchor.constraint(equalToConstant: 53).isActive = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    private let leadingIcon: UIImageView = {
        let view = UIImageView()
        view.widthAnchor.constraint(equalToConstant: 20).isActive = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        view.tintColor = ColorPalette.shared.gray_CCCCCC
        return view
    }()
    
    let textField: UITextField = {
        let view = UITextField()
        view.font = .systemFont(ofSize: 14)
        view.tintColor = ColorPalette.shared.blue_0077B6
        return view
    }()
    
    private let trailingIcon: UIImageView = {
        let view = UIImageView()
        view.widthAnchor.constraint(equalToConstant: 20).isActive = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        view.tintColor = ColorPalette.shared.gray_CCCCCC
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 10
        
        textField.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        
        hStack.addArrangedSubview(leadingIcon)
        hStack.addArrangedSubview(textField)
        hStack.addArrangedSubview(trailingIcon)
        
        addArrangedSubview(label)
        addArrangedSubview(hStack)
    }
    
    func configure(labelText: String? = nil, placeholder: String, text: String? = nil, leading: UIImage? = nil, trailing: UIImage? = nil) {
        if let labelText = labelText {
            label.text = labelText
            label.isHidden = false
        }
        textField.text = text
        textField.placeholder = placeholder
        if let leading = leading {
            leadingIcon.image = leading
            leadingIcon.isHidden = false
        }
        if let trailing = trailing {
            trailingIcon.image = trailing
            trailingIcon.isHidden = false
        }
    }
    
    @objc private func editingDidBegin() {
        hStack.layer.borderColor = ColorPalette.shared.blue_0077B6.cgColor
        leadingIcon.tintColor = ColorPalette.shared.blue_0077B6
        trailingIcon.tintColor = ColorPalette.shared.blue_0077B6
    }
    
    @objc private func editingDidEnd() {
        hStack.layer.borderColor = ColorPalette.shared.gray_CCCCCC.cgColor
        leadingIcon.tintColor = ColorPalette.shared.gray_CCCCCC
        trailingIcon.tintColor = ColorPalette.shared.gray_CCCCCC
    }
}
