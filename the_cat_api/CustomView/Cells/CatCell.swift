//
//  CatCell.swift
//  the_cat_api
//
//  Created by Valeriia Zakharova on 25.03.2022.
//

import UIKit

class CatCell: UICollectionViewCell {

    static let reuseID = "CatCell"

    private let catImageView = CatImageView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(cat: Cats) {
        catImageView.downloadImage(fromUrl: cat.url)
    }
}

// MARK: - Private

private extension CatCell {
    func setup() {
        setupViewHierarchy()
        setupLayout()
        setupStyle()
    }

    func setupViewHierarchy() {
        contentView.addSubview(catImageView)
    }

    func setupLayout() {
        catImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setupStyle() {
        backgroundColor = .white
        contentView.backgroundColor = .white
        contentMode = .scaleAspectFit
    }
}
