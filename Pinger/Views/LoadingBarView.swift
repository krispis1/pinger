//
//  LoadingBarView.swift
//  Pinger
//
//  Created by Macbook on 2020-11-18.
//

import UIKit

class LoadingBarView: UIView {

    private let loadingBar = UIProgressView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(loadingBar)
        setupLoadingBar()
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            self.updateProgressBar()
        }
        timer.fire()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLoadingBar() {
        DispatchQueue.main.async { [self] in
            loadingBar.translatesAutoresizingMaskIntoConstraints = false
            loadingBar.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
            loadingBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -1).isActive = true
            loadingBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 1).isActive = true
            loadingBar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }
    }
    
    func updateProgressBar() {
        loadingBar.setProgress(Float(Double(scannedIps.count) / 254.0), animated: true)
    }

}
