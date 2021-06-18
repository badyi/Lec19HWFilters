//
//  PreviewCell.swift
//  Lec19HWFilters
//
//  Created by badyi on 17.06.2021.
//

import UIKit

final class PreviewCell: UICollectionViewCell {
    static let id = "PreviceCell"
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

extension PreviewCell {
    func configView(with image: UIImage?) {
        imageView.image = image
        spinner.stopAnimating()
    }
}

extension PreviewCell {
    private func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(spinner)
        spinner.startAnimating()
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: contentView.topAnchor),
            spinner.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spinner.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            spinner.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
