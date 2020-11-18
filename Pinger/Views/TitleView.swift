//
//  PingerView.swift
//  Pinger
//
//  Created by Macbook on 2020-11-13.
//

import UIKit

class TitleView: UIView {
    
    private let screen = UIScreen.main.bounds
    private let spacing = (UIScreen.main.bounds.width - (UIScreen.main.bounds.width/4.5*4)) / 5
    
    private let title: UILabel = {
        let title = UILabel()
        title.numberOfLines = 1
        title.text = "IP Reachability"
        title.font = UIFont(name: "DMSans-Regular", size: 25)
        title.font = title.font.withSize(25)
        title.textColor = .black
        title.textAlignment = .left
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(title)
        setupTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitle() {
        DispatchQueue.main.async { [self] in
            title.translatesAutoresizingMaskIntoConstraints = false
            title.heightAnchor.constraint(equalToConstant: 40).isActive = true
            title.widthAnchor.constraint(equalToConstant: screen.width - spacing).isActive = true
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: spacing).isActive = true
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing).isActive = true
        }
    }
}
