//
//  PhotoViewProtocol.swift
//  Lec19HWFilters
//
//  Created by badyi on 16.06.2021.
//

import UIKit

protocol PhotoViewProtocol: AnyObject {
    func viewDidLoad()
    func showPreview()
    func hidePreview()
    func setImage(_ image: UIImage)
    func updateCell(at index: IndexPath)
    func updateImage()
    func updatePreviews()
}

