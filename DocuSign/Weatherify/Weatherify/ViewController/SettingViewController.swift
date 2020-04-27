//
//  SettingViewController.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/27/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    private let settingVM = SettingViewModel.shared

    private let cellId = "optionCell"
    private let rowHeight = CGFloat(40)

    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.5
    public var animationDuration: TimeInterval = 0.2

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        return mainView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView.delegate = self
        self.tableView.dataSource = self

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        self.view.addGestureRecognizer(panGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        self.mainView.addGestureRecognizer(tapGesture)

        initView()
    }

    private func initView() {
        self.view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                              constant: 20),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(settingVM.fetchCities().count+2) * rowHeight)
        ])

        self.view.addSubview(mainView)

        NSLayoutConstraint.activate([
            mainView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.tableView.topAnchor),
            mainView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            mainView.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
    }

    @objc
    private func panGesture(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view?.window)
        var initialTouchPoint = CGPoint.zero

        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y > initialTouchPoint.y {
                view.frame.origin.y = touchPoint.y - initialTouchPoint.y
            }
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 200 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: self.view.frame.size.width,
                                             height: self.view.frame.size.height)
                })
            }
        case .failed, .possible:
            break
        default:
            break
        }
    }

    @objc
    private func tapGesture(_ sender: UITapGestureRecognizer) {
        self.navigationController?.dismiss(animated: true, completion: {
            print("dismiss")
        })
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.dismiss(animated: true, completion: {
            self.settingVM.removeCity(for:indexPath.row)
        })
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingVM.fetchCities().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
        cell.textLabel?.text = settingVM.getCity(for: indexPath.row)
        cell.textLabel?.font = appFont(section: .desc)
        cell.textLabel?.tag = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }
}
