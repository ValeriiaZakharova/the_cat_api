//
//  CategoryViewController.swift
//  the_cat_api
//
//  Created by Valeriia Zakharova on 25.03.2022.
//

import UIKit

class CategoryViewController: UIViewController {

    var category: Category?
    var cats: [Cats] = []

    // MARK: - Private properties

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private let categoryService = ServiceLocator.shared.categoriesService

    init(category: Category) {
        super.init(nibName: nil, bundle: nil)
        self.category = category
        title = category.name
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overriden

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getCategory()
        setup()
    }

    func getCategory() {
        guard let category = category else { return }
        self.showSpinner(onView: self.view)
        categoryService.fetchCategory(categoryId: category.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cats):
                self.cats = cats
                self.collectionView.reloadData()
                self.removeSpinner()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func makeStaticColumnFlowLayout(in view: UIView, columns: Int) -> UICollectionViewLayout {
        let columnsCount = CGFloat(columns)
        let width = view.bounds.width
        let padding: CGFloat = 20
        let minimumItemSpasing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpasing * (columnsCount - 1))
        let itemWidth = availableWidth / columnsCount

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        return flowLayout
    }
}

private extension CategoryViewController {
    func setup() {
        setupViewHierarchy()
        setupLayout()
        setupStyle()
        setupContent()
        setupCollectionView()
        setupNavBar()
    }

    func setupViewHierarchy() {
        view.addSubview(collectionView)
    }

    func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setupStyle() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
    }

    func setupContent() {
        guard let name = category?.name else { return }
        title = name
    }

    func setupCollectionView() {
        collectionView.collectionViewLayout = makeStaticColumnFlowLayout(in: view, columns: 2)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseID)
    }

    func setupNavBar() {
        let label = UILabel()
        label.text = title
        label.font = .boldSystemFont(ofSize: 16)
        navigationItem.titleView = label
        self.navigationController?.navigationBar.tintColor = .gray
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseID, for: indexPath) as? CategoryCell else {
            assertionFailure("Unexpected cell type")
            return .init()
        }

        cell.set(cat: cats[indexPath.row])
        return cell
    }

}
