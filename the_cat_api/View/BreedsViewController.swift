//
//  BreedsViewController.swift
//  the_cat_api
//
//  Created by Valeriia Zakharova on 01.04.2022.
//

import UIKit

class BreedsViewController: UIViewController {

    var breeds: [Breed] = []

    // MARK: - Private properties

    private let breedsService = ServiceLocator.shared.categoriesService

    private let tableView = UITableView()

    // MARK: - Overriden

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getBreeds()
    }

    func getBreeds() {
        breedsService.fetchBreeds { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let breeds):
                self.breeds = breeds
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Private
private extension BreedsViewController {

    func setup() {
        setupViewHierarchy()
        setupLayout()
        setupStyle()
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

    func setupTableView() {
        tableView.bounces = true
        tableView.isScrollEnabled = true

        tableView.delegate = self
        tableView.dataSource = self

        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(NameCell.self, forCellReuseIdentifier: NameCell.reuseID)
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
extension BreedsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NameCell.reuseID) as? NameCell else {
            assertionFailure("Unexpected cell type")
            return .init()
        }

        cell.set(model: breeds[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let viewController = BreedDetailsViewController()

        navigationController?.pushViewController(viewController, animated: true)
    }
}
