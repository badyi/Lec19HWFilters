//
//  PhotoModel.swift
//  Lec19HWFilters
//
//  Created by badyi on 17.06.2021.
//

import UIKit

final class PhotoModel {
    public private(set) var image: UIImage
    public private(set) var originalImage: UIImage
    public private(set) var edited: Bool
    
    init(with image: UIImage) {
        self.image = image
        originalImage = image
        edited = false
    }
    
    func setEdited(_ image: UIImage) {
        edited = true
        self.image = image
    }
    
    func revertToOriginal() {
        image = originalImage
        edited = false
    }
}
