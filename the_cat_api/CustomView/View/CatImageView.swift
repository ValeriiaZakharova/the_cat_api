//
//  CatImageView.swift
//  the_cat_api
//
//  Created by Valeriia Zakharova on 25.03.2022.
//

import UIKit

class CatImageView: UIImageView {

    private let imageService = ServiceLocator.shared.imageService

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func downloadImage(fromUrl url: String) {
        imageService.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }
}

private extension CatImageView {
    func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}

