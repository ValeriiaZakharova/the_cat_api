//
//  CategoryCell.swift
//  the_cat_api
//
//  Created by Valeriia Zakharova on 25.03.2022.
//

import UIKit
import SnapKit

class CategoryCell: UITableViewCell {

    static let reuseID = "CategoryCell"

    // MARK: - Private properties
    private let containerView = UIView()

    private let titleLabel = UILabel()

    private let arrowImageView = UIImageView()

    // MARK: - Overriden
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(model: Category) {
        titleLabel.text = model.name
    }
}

private extension CategoryCell {
    func setup() {
        setupViewHierarchy()
        setupLayout()
        setupStyle()
        setupContent()
    }

    func setupViewHierarchy() {
        contentView.addSubview(containerView)

        containerView.addSubview(titleLabel)
        containerView.addSubview(arrowImageView)
    }

    func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(4)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(16)
        }

        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(18)
            make.size.equalTo(14)
        }
    }

    func setupStyle() {
        backgroundColor = .white
        contentView.backgroundColor = .white

        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.gray.cgColor

        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 16)
    }

    func setupContent() {
        arrowImageView.image = Images.arrow
    }
}
