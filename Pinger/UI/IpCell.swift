//
//  IpCell.swift
//  Pinger
//
//  Created by Macbook on 2020-11-14.
//

import UIKit

class IpCell: UITableViewCell {
    
    let ipLabel = UILabel()
    let statusImage = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(ipLabel)
        addSubview(statusImage)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        selectionStyle = .none
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
        ipLabel.numberOfLines = 1
        ipLabel.adjustsFontSizeToFitWidth = true
        ipLabel.translatesAutoresizingMaskIntoConstraints = false
        ipLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        ipLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        ipLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        ipLabel.trailingAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        statusImage.clipsToBounds = true
        statusImage.translatesAutoresizingMaskIntoConstraints = false
        statusImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        statusImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        statusImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        statusImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
}
