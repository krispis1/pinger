//
//  ViewController.swift
//  Pinger
//
//  Created by Macbook on 2020-11-12.
//

import UIKit

let tableView = UITableView()
var scannedIps = [IpBlock]()

class HomeViewController: UIViewController {
    
    let titleView = TitleView()
    let controlsView = ControlsView()
    let sortingView = SortingView()
    let loadingBarView = LoadingBarView()
    
    let screen = UIScreen.main.bounds
    let spacing = (UIScreen.main.bounds.width - (UIScreen.main.bounds.width/4.5*4)) / 5

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
               selector: #selector(didExpand),
               name: NSNotification.Name(rawValue: "didExpand"),
               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didExpand() {
        
        if controlsView.isExpanded() == false {
            view.addSubview(sortingView)
            sortingView.alpha = 0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.sortingView.alpha = 1.0
            }, completion: nil)
            sortingView.translatesAutoresizingMaskIntoConstraints = false
            sortingView.heightAnchor.constraint(equalToConstant: 80 + spacing).isActive = true
            sortingView.widthAnchor.constraint(equalToConstant: screen.width/2 - spacing*2).isActive = true
            sortingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing).isActive = true
            sortingView.bottomAnchor.constraint(equalTo: controlsView.topAnchor).isActive = true
        } else {
            UIView.animate(withDuration: 0.05, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.sortingView.alpha = 0.0
            }, completion: {(value: Bool) in
                self.sortingView.removeFromSuperview()})
        }
    }
    
    func setupView() {
        DispatchQueue.main.async { [self] in
            let height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            
            view.addSubview(titleView)
            titleView.layer.borderColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1.0).cgColor
            titleView.layer.borderWidth = 0.5
            titleView.translatesAutoresizingMaskIntoConstraints = false
            titleView.heightAnchor.constraint(equalToConstant: 40 + spacing*2 + height + 0.5).isActive = true
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -1).isActive = true
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 1).isActive = true
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: -0.5).isActive = true
            
            view.addSubview(loadingBarView)
            loadingBarView.layer.borderColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1.0).cgColor
            loadingBarView.layer.borderWidth = 0.5
            loadingBarView.translatesAutoresizingMaskIntoConstraints = false
            loadingBarView.heightAnchor.constraint(equalToConstant: 10).isActive = true
            loadingBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            loadingBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            loadingBarView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -0.5).isActive = true
            
            view.addSubview(controlsView)
            controlsView.layer.borderColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1.0).cgColor
            controlsView.layer.borderWidth = 0.5
            controlsView.translatesAutoresizingMaskIntoConstraints = false
            controlsView.heightAnchor.constraint(equalToConstant: 40 + spacing*2 + 0.5).isActive = true
            controlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -1).isActive = true
            controlsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 1).isActive = true
            controlsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.5).isActive = true
            
            view.addSubview(Pinger.tableView)
            Pinger.tableView.delegate = self
            Pinger.tableView.dataSource = self
            Pinger.tableView.rowHeight = 60
            Pinger.tableView.translatesAutoresizingMaskIntoConstraints = false
            Pinger.tableView.topAnchor.constraint(equalTo: loadingBarView.bottomAnchor).isActive = true
            Pinger.tableView.bottomAnchor.constraint(equalTo: controlsView.topAnchor, constant: 0.5).isActive = true
            Pinger.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            Pinger.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
            view.bringSubviewToFront(controlsView)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scannedIps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IpCell()
        cell.ipLabel.text = scannedIps[scannedIps.count-1-indexPath.row].ip
        cell.statusImage.image = scannedIps[scannedIps.count-1-indexPath.row].statusImg
        return cell
    }
}

