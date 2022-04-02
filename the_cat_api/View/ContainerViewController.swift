//
//  MainViewController.swift
//  the_cat_api
//
//  Created by Valeriia Zakharova on 01.04.2022.
//

import UIKit

class ContainerViewController: UIViewController {

    // MARK: - Private

    private let segmentControl = UISegmentedControl(items: [])

    private lazy var categoriesViewController = CategoriesListViewController()

    private lazy var breedsViewController = BreedsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        //initial view controller
        add(asChildViewController: categoriesViewController)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)

        viewController.view.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(segmentControl.snp.bottom)
        }

        viewController.didMove(toParent: self)
    }

    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    @objc func valueChanged(sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            remove(asChildViewController: breedsViewController)
            add(asChildViewController: categoriesViewController)
        case 1:
            remove(asChildViewController: categoriesViewController)
            add(asChildViewController: breedsViewController)
        default:
            assertionFailure("Unexpected segment index")
        }
    }
}

private extension ContainerViewController {
    func setup() {
        setupViewHierarchy()
        setupLayout()
        setupStyle()
        setupSegmentControl()
    }

    func setupViewHierarchy() {
        view.addSubview(segmentControl)
    }

    func setupLayout() {
        segmentControl.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.height.equalTo(80)
            make.width.equalToSuperview()
        }
    }

    func setupStyle() {
        view.backgroundColor = .white
    }

    func setupSegmentControl() {
        segmentControl.insertSegment(withTitle: Localization.categoriesTitle, at: 0, animated: false)
        segmentControl.insertSegment(withTitle: Localization.breedsTitle, at: 1, animated: false)
        segmentControl.selectedSegmentIndex = 0

        let font = UIFont.systemFont(ofSize: 20)

        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ], for: .normal)

        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ], for: .selected)

        //remove background
        if #available(iOS 13.0, *) {
          let image = UIImage()
          let size = CGSize(width: 1, height: segmentControl.intrinsicContentSize.height)
          UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
          image.draw(in: CGRect(origin: .zero, size: size))
          let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            segmentControl.setBackgroundImage(scaledImage, for: .normal, barMetrics: .default)
            segmentControl.setDividerImage(scaledImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        }

        segmentControl.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
}
