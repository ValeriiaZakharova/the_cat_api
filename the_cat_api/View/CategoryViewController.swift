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
        categoryService.fetchCategory(category_ids: category) { [weak self] cats, error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.cats = cats
                self.collectionView.reloadData()
                self.removeSpinner()
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
        collectionView.register(CatCell.self, forCellWithReuseIdentifier: CatCell.reuseID)
    }

    func setupNavBar() {
        let label = UILabel()
        label.text = title
        label.font = .boldSystemFont(ofSize: 16)
        navigationItem.titleView = label
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {

//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print(#function)
//        lalalal()
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print(#function)
//        guard !decelerate else {
//            print("Decelerate is enabled, ignoring")
//            return
//        }
//        lalalal()
//    }
//
//    func lalalal() {
//        let offsetY = collectionView.contentOffset.y
//        let contentHeight = collectionView.contentSize.height
//        let height = collectionView.frame.size.height
//
//        if offsetY > contentHeight - height {
//            print("Start FETCHING")
//        }
//    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatCell.reuseID, for: indexPath) as? CatCell else {
            assertionFailure("Unexpected cell type")
            return .init()
        }

        cell.set(cat: cats[indexPath.row])
        return cell
    }

}
