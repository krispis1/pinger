import UIKit

class ActionButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupButton() {
        titleLabel?.font = UIFont(name: "DMSans-Regular", size: 13)
        titleLabel?.font = titleLabel?.font.withSize(13)
        layer.borderWidth = 0
        setTitleColor(UIColor.white, for: .normal)
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        layer.cornerRadius = 10
    }
    
}
