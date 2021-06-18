//
//  PhotoViewControllerProtocol.swift
//  Lec19HWFilters
//
//  Created by badyi on 16.06.2021.
//

import UIKit

protocol PhotoViewControllerProtocol: AnyObject {
    func filtersCount() -> Int
    func preview(at index: IndexPath) -> UIImage?
    func didSelect(at index: IndexPath)
    func image() -> UIImage
}
