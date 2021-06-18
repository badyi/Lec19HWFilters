//
//  ViewController.swift
//  Lec19HWFilters
//
//  Created by badyi on 16.06.2021.
//

import UIKit

final class PhotoViewController: UIViewController {
    
    private var photoView: PhotoViewProtocol
    private var imagePicker: UIImagePickerController
    private var filters = ["original", "CIColorMonochrome", "CISepiaTone", "CIBloom", "CIGloom","CIVignette", "CIDither", "CIEdges"]
    private var photo: PhotoModel
    private let filterQueue = DispatchQueue(label: "filterQueue", attributes: .concurrent)
    private let context = CIContext(options: nil)
    
    private var previews: [UIImage?] = []
    private var currentSelected: Int = 0
    
    init(with view: PhotoViewProtocol) {
        photoView = view
        imagePicker = UIImagePickerController()
        photo = PhotoModel(with: UIImage(named: "defaultImage")!)
        for _ in filters {
            previews.append(nil)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = (photoView as! UIView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.viewDidLoad()
        photoView.setImage(photo.image)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        configFilters()
    }
}

extension PhotoViewController {
    private func configFilters() {
        for i in 0..<filters.count {
            let filterName = filters[i]
            if filterName == "original" {
                previews[i] = photo.image
                continue
            }
            filterQueue.async { [weak self] in
                let image = self?.doFilter(self?.photo.image, filterName)
                self?.previews[i] = image
                DispatchQueue.main.async {
                    self?.photoView.updateCell(at: IndexPath(row: i, section: 0))
                }
            }
        }
    }
    
    private func doFilter(_ image: UIImage?, _ filterName: String, _ intensity: CGFloat = 0.5) -> UIImage? {
        guard let image = image else {
            return nil
        }
        if let filter = CIFilter(name: filterName) {
            let ciImage = CIImage(image: image)
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            filter.setValue(intensity, forKeyPath: kCIInputIntensityKey)
            if let filteredImage = filter.outputImage, let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent){
                return UIImage(cgImage: cgImage)
            }
        }
        return image
    }
}

extension PhotoViewController: PhotoViewControllerProtocol {
    func image() -> UIImage {
        return photo.image
    }
    
    func didSelect(at index: IndexPath) {
        currentSelected = index.row
        let filterName = filters[index.row]
        if filterName == "original" {
            photoView.setImage(photo.originalImage)
            return
        }
        if let image = previews[index.row] {
            photoView.setImage(image)
        }
    }
    
    func preview(at index: IndexPath) -> UIImage? {
        return previews[index.row]
    }
    
    func filtersCount() -> Int {
        return filters.count
    }
}

extension PhotoViewController {
    @objc private func editTapped() {
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        let setings = UIBarButtonItem(image: .actions, style: .plain, target: self, action: #selector(settingsTapped))
        navigationItem.rightBarButtonItems = [save, setings]
        photoView.showPreview()
    }
    
    @objc private func cancelTapped() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        photoView.hidePreview()
        photoView.updateImage()
    }
    
    @objc private func addTapped() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc private func saveTapped() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        photoView.hidePreview()
        save()
    }
    
    @objc private func settingsTapped() {
        let settings = SettingsViewController()
        settings.callback = { [weak self] value in
            self?.filterQueue.async { [weak self] in
                guard let current = self?.currentSelected else { return }
                guard let filterName = self?.filters[current] else { return }
                if filterName == "original" {
                    return
                }
                guard let image = self?.doFilter(self?.photo.image, filterName, value) else { return }
                self?.previews[current] = image
                DispatchQueue.main.async {
                    self?.photoView.setImage(image)
                }
            }
        }
        navigationController?.pushViewController(settings, animated: true)
    }
    
    private func save() {
        if let image = previews[currentSelected] {
            photo.setEdited(image)
        }
    }
}

extension PhotoViewController: UINavigationControllerDelegate {
        
}

extension PhotoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photo = PhotoModel(with: image)
            for i in 0..<previews.count {
                previews[i] = nil
            }
            photoView.updatePreviews()
            photoView.updateImage()
            configFilters()
            imagePicker.dismiss(animated: true, completion: nil);
        }
    }
}
