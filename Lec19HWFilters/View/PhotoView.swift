//
//  PhotoView.swift
//  Lec19HWFilters
//
//  Created by badyi on 16.06.2021.
//

import UIKit

final class PhotoView: UIView {
    weak var controller: PhotoViewControllerProtocol?
    
    private var previewIsVisibleConstraint: NSLayoutConstraint?
    private var previewIsHiddenConstraint: NSLayoutConstraint?
    private var previewHeightConstraint: NSLayoutConstraint?
    private var editMode: Bool = false
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var previewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        cv.register(PreviewCell.self, forCellWithReuseIdentifier: PreviewCell.id)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
}

extension PhotoView: PhotoViewProtocol {
    func updatePreviews() {
        previewCollectionView.reloadData()
    }
    
    func updateImage() {
        imageView.image = controller?.image()
    }
    
    func updateCell(at index: IndexPath) {
        previewCollectionView.reloadItems(at: [index])
    }
    
    func viewDidLoad() {
        addSubview(imageView)
        addSubview(previewCollectionView)
        previewIsVisibleConstraint = imageView.bottomAnchor.constraint(equalTo: previewCollectionView.topAnchor)
        previewIsHiddenConstraint = imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        previewHeightConstraint = previewCollectionView.heightAnchor.constraint(equalToConstant: 100)
        hidePreview()
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            previewCollectionView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            previewCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            previewCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            previewCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func showPreview() {
        editMode = true
        previewCollectionView.isHidden = false
        previewIsHiddenConstraint?.isActive = false
        previewIsVisibleConstraint?.isActive = true
        previewHeightConstraint?.isActive = true
    }
    
    func hidePreview() {
        editMode = false
        previewCollectionView.isHidden = true
        previewHeightConstraint?.isActive = false
        previewIsVisibleConstraint?.isActive = false
        previewIsHiddenConstraint?.isActive = true
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    
}

extension PhotoView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller?.didSelect(at: indexPath)
    }
}

extension PhotoView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller?.filtersCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCell.id, for: indexPath) as! PreviewCell
        
        if let image = controller?.preview(at: indexPath) {
            cell.configView(with: image)
        } else {
            cell.spinner.startAnimating()
        }
        
        return cell
    }
}

extension PhotoView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height - 2
        let width = height - 2
        return CGSize (width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
