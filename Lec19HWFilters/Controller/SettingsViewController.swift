//
//  SettingsViewController.swift
//  Lec19HWFilters
//
//  Created by badyi on 18.06.2021.
//

import UIKit

final class SettingsViewController: UIViewController {
    var callback: ((CGFloat) -> ())?
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = 0.5
        slider.minimumValue = 0
        slider.maximumValue = 1
        return slider
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupView()
    }
}

extension SettingsViewController {
    private func setupView() {
        view.addSubview(slider)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            slider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            slider.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            saveButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func saveTapped() {
        callback?(CGFloat(slider.value))
        navigationController?.popViewController(animated: true)
    }
}
