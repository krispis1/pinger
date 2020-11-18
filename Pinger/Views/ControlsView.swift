//
//  ControlsView.swift
//  Pinger
//
//  Created by Macbook on 2020-11-15.
//

import UIKit

class ControlsView: UIView {
    
    let sortingView = SortingView()
    let ipPinger = IpPinger()
    
    private let screen = UIScreen.main.bounds
    private let spacing = (UIScreen.main.bounds.width - (UIScreen.main.bounds.width/4.5*4)) / 5
    
    private var expanded = false
    private var pinging = false
    
    var timer : Timer?
    
    func isExpanded() -> Bool {
        return expanded
    }
    
    func setExpanded(expanded: Bool) {
        self.expanded = expanded
    }
    
    func isPinging() -> Bool {
        return pinging
    }
    
    func setPinging(pinging: Bool) {
        self.pinging = pinging
    }
    
    func startTimer()
    {
      if timer == nil {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            if scannedIps.count == 254 {
                self.stopPinger()
            }
        }
      }
    }

    func stopTimer()
    {
      if timer != nil {
        timer!.invalidate()
        timer = nil
      }
    }
    
    private let sortButton: ActionButton = {
        let sortButton = ActionButton()
        sortButton.setTitle("Sort", for: .normal)
        sortButton.backgroundColor = UIColor(red: 20/255, green: 126/255, blue: 251/255, alpha: 1)
        return sortButton
    }()
    
    private let pingButton: ActionButton = {
        let pingButton = ActionButton()
        pingButton.setTitle("Start", for: .normal)
        pingButton.backgroundColor = UIColor(red: 83/255, green: 215/255, blue: 105/255, alpha: 1)
        return pingButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupButtons()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            if scannedIps.count == 254 {
                self.stopPinger()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtons() {
        DispatchQueue.main.async { [self] in
            addSubview(sortButton)
            sortButton.translatesAutoresizingMaskIntoConstraints = false
            sortButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            sortButton.widthAnchor.constraint(equalToConstant: screen.width/2 - spacing*2).isActive = true
            sortButton.leftAnchor.constraint(equalTo: leftAnchor, constant: spacing).isActive = true
            sortButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing).isActive = true
            sortButton.addTarget(self, action: #selector(sortOnClick), for: .touchUpInside)

            addSubview(pingButton)
            pingButton.translatesAutoresizingMaskIntoConstraints = false
            pingButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            pingButton.widthAnchor.constraint(equalToConstant: screen.width/2 - spacing*2).isActive = true
            pingButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -spacing).isActive = true
            pingButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing).isActive = true
            pingButton.addTarget(self, action: #selector(pingOnClick), for: .touchUpInside)
        }
    }
    
    @objc func sortOnClick() {
        
        if isExpanded() == false {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.sortButton.backgroundColor = UIColor(red: 91/255, green: 165/255, blue: 252/255, alpha: 1)
            }, completion: nil)
            UIView.animate(withDuration: 0.2, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.sortButton.backgroundColor = UIColor(red: 253/255, green: 100/255, blue: 97/255, alpha: 1)
            }, completion: nil)
            UIView.animate(withDuration: 0.2, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.sortButton.backgroundColor = UIColor(red: 252/255, green: 61/255, blue: 57/255, alpha: 1)
            }, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didExpand"), object: nil)
            setExpanded(expanded: true)
            sortButton.setTitle("✕", for: .normal)
        } else {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.sortButton.backgroundColor = UIColor(red: 253/255, green: 100/255, blue: 97/255, alpha: 1)
            }, completion: nil)
            UIView.animate(withDuration: 0.2, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.sortButton.backgroundColor = UIColor(red: 91/255, green: 165/255, blue: 252/255, alpha: 1)
            }, completion: nil)
            UIView.animate(withDuration: 0.2, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.sortButton.backgroundColor = UIColor(red: 20/255, green: 126/255, blue: 251/255, alpha: 1)
            }, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didExpand"), object: nil)
            setExpanded(expanded: false)
            sortButton.setTitle("Sort", for: .normal)
        }
    }
    
    @objc func pingOnClick() {
        if isPinging() == false {
            scannedIps.removeAll()
            startTimer()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.pingButton.backgroundColor = UIColor(red: 135/255, green: 227/255, blue: 150/255, alpha: 1)
            }, completion: nil)
            UIView.animate(withDuration: 0.2, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.pingButton.backgroundColor = UIColor(red: 253/255, green: 100/255, blue: 97/255, alpha: 1)
            }, completion: nil)
            UIView.animate(withDuration: 0.2, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.pingButton.backgroundColor = UIColor(red: 252/255, green: 61/255, blue: 57/255, alpha: 1)
            }, completion: nil)
            setPinging(pinging: true)
            pingButton.setTitle("Stop", for: .normal)
            ipPinger.concurrentPing(it: 1, diff: 0, firstRun: true)
        } else {
            stopTimer()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.pingButton.backgroundColor = UIColor(red: 253/255, green: 100/255, blue: 97/255, alpha: 1)
            }, completion: nil)
            UIView.animate(withDuration: 0.2, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.pingButton.backgroundColor = UIColor(red: 135/255, green: 227/255, blue: 150/255, alpha: 1)
            }, completion: nil)
            UIView.animate(withDuration: 0.2, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.pingButton.backgroundColor = UIColor(red: 83/255, green: 215/255, blue: 105/255, alpha: 1)
            }, completion: nil)
            setPinging(pinging: false)
            pingButton.setTitle("Start", for: .normal)
            ipPinger.stopPinging()
        }
    }
    
    @objc func stopPinger() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.pingButton.backgroundColor = UIColor(red: 253/255, green: 100/255, blue: 97/255, alpha: 1)
        }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.pingButton.backgroundColor = UIColor(red: 135/255, green: 227/255, blue: 150/255, alpha: 1)
        }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.pingButton.backgroundColor = UIColor(red: 83/255, green: 215/255, blue: 105/255, alpha: 1)
        }, completion: nil)
        setPinging(pinging: false)
        pingButton.setTitle("Start", for: .normal)
        ipPinger.stopPinging()
        stopTimer()
    }

}
