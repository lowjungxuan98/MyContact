import UIKit

class CircleAvatarView: UIView {
    
    private let label: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.isHidden = true
        return view
    }()
    
    private let image: UIImageView = {
        let view = UIImageView()
        view.image = MyImage.shared.icPerson
        view.tintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
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
        addSubview(image)
        backgroundColor = ColorPalette.shared.blue_0077B6
        layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            image.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width / 2
    }
    
    func configure(with text: String, font: UIFont) {
        label.text = text
        label.font = font
        label.isHidden = false
        image.isHidden = true
    }
}
