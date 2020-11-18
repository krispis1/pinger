//
//  SortingView.swift
//  Pinger
//
//  Created by Macbook on 2020-11-15.
//

import UIKit

class SortingView: UIView {
    
    private let screen = UIScreen.main.bounds
    private let spacing = (UIScreen.main.bounds.width - (UIScreen.main.bounds.width/4.5*4)) / 5
    
    var ipSortDown = false
    var reachSortDown = false
    
    private let sortByIp: ActionButton = {
        let sortByIp = ActionButton()
        sortByIp.setTitle("IP ↑↓", for: .normal)
        sortByIp.backgroundColor = .systemBlue
        return sortByIp
    }()
    
    private let sortByReach: ActionButton = {
        let sortByReach = ActionButton()
        sortByReach.setTitle("Reachability ↑↓", for: .normal)
        sortByReach.backgroundColor = .systemBlue
        return sortByReach
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = true
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtons() {
        DispatchQueue.main.async { [self] in
            addSubview(sortByReach)
            sortByReach.translatesAutoresizingMaskIntoConstraints = false
            sortByReach.heightAnchor.constraint(equalToConstant: 40).isActive = true
            sortByReach.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            sortByReach.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            sortByReach.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            sortByReach.addTarget(self, action: #selector(sortByReachClick), for: .touchUpInside)
            
            addSubview(sortByIp)
            sortByIp.translatesAutoresizingMaskIntoConstraints = false
            sortByIp.heightAnchor.constraint(equalToConstant: 40).isActive = true
            sortByIp.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            sortByIp.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            sortByIp.topAnchor.constraint(equalTo: topAnchor).isActive = true
            sortByIp.addTarget(self, action: #selector(sortByIpClick), for: .touchUpInside)
        }
    }
    
    @objc func sortByReachClick() {
        if ipSortDown == false {
            reachSortDown = false
            ipSortDown = true
            scannedIps.sort {$0.status && !$1.status}
            sortByIp.setTitle("IP ↑↓", for: .normal)
            sortByReach.setTitle("Reachability ↓", for: .normal)
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        } else {
            reachSortDown = false
            ipSortDown = false
            scannedIps.sort {!$0.status && $1.status}
            sortByIp.setTitle("IP ↑↓", for: .normal)
            sortByReach.setTitle("Reachability ↑", for: .normal)
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.sortByReach.backgroundColor = UIColor(red: 91/255, green: 165/255, blue: 252/255, alpha: 1)
        }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.sortByReach.backgroundColor = UIColor(red: 20/255, green: 126/255, blue: 251/255, alpha: 1)
        }, completion: nil)
    }
    
    @objc func sortByIpClick() {
        if reachSortDown == false {
            ipSortDown = false
            reachSortDown = true
            scannedIps.sort {$0.ipEnd < $1.ipEnd}
            sortByIp.setTitle("IP ↓", for: .normal)
            sortByReach.setTitle("Reachability ↑↓", for: .normal)
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        } else {
            ipSortDown = false
            reachSortDown = false
            scannedIps.sort {$0.ipEnd > $1.ipEnd}
            sortByIp.setTitle("IP ↑", for: .normal)
            sortByReach.setTitle("Reachability ↑↓", for: .normal)
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.sortByIp.backgroundColor = UIColor(red: 91/255, green: 165/255, blue: 252/255, alpha: 1)
        }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.sortByIp.backgroundColor = UIColor(red: 20/255, green: 126/255, blue: 251/255, alpha: 1)
        }, completion: nil)
    }


}
