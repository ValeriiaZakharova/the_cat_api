//
//  ViewController.swift
//  the_cat_api
//
//  Created by Valeriia Zakharova on 24.03.2022.
//

import UIKit
import SnapKit

class CategoriesListViewController: UIViewController {

    var categories: [Category] = []

    // MARK: - Private properties

    private let categoriesService = ServiceLocator.shared.categoriesService

    private let tableView = UITableView()

    // MARK: - Overriden

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getCategorise()
    }

    func getCategorise() {
        categoriesService.fetchCategories { [weak self] categories, error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.categories = categories
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - Private
private extension CategoriesListViewController {

    func setup() {
        setupViewHierarchy()
        setupLayout()
        setupStyle()
        setupContent()
        setupNavBar()
        setupTableView()
    }

    func setupViewHierarchy() {
        view.addSubview(tableView)
    }

    func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setupStyle() {
        view.backgroundColor = .white
        tableView.backgroundColor = .white
    }

    func setupContent() {
        title = Localization.categoriesTitle
    }

    func setupTableView() {
        tableView.bounces = true
        tableView.isScrollEnabled = true

        tableView.delegate = self
        tableView.dataSource = self

        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(CategoryNameCell.self, forCellReuseIdentifier: CategoryNameCell.reuseID)
    }

    func setupNavBar() {
        let label = UILabel()
        label.text = title
        label.font = .boldSystemFont(ofSize: 16)

        navigationItem.titleView = label
        navigationItem.backButtonTitle = ""
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CategoriesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryNameCell.reuseID) as? CategoryNameCell else {
            assertionFailure("Unexpected cell type")
            return .init()
        }

        cell.set(model: categories[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let category = categories[indexPath.row]
        let viewController = CategoryViewController(category: category)

        navigationController?.pushViewController(viewController, animated: true)
    }
}

