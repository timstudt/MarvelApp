//
//  CharacterCollectionView.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import UIKit

extension CharacterCollectionView {
    static func view(
        builder: CharacterCollectionModuleBuilder = CharacterCollectionModuleBuilder())
        -> CharacterCollectionView {
        let view = self.init()
        return builder
            .add(presenter: CharacterCollectionPresenter.presenter())
            .add(view: view)
            .add(router: CharacterCollectionRouter())
            .build()
    }
}

final class CharacterCollectionView: UIViewController, PresenterOutput {

    // MARK: - Module
    var dataSource: CharacterCollectionDataSource?
    var router: CharacterCollectionRoutable?
    var collectionViewDataSource = CollectionViewDataSource<CharacterCollectionViewCellConfigurator>()
    let searchController = UISearchController(searchResultsController: nil)

    // MARK: - subiews
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100,
                                     height: 100)
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.sectionInset = UIEdgeInsets(top: 8,
                                               left: 8,
                                               bottom: 8,
                                               right: 8)
        flowLayout.scrollDirection = .vertical
        flowLayout.headerReferenceSize = CGSize(width: 320,
                                                height: 20)
        let collectionView = UICollectionView(frame: view.bounds,
                                              collectionViewLayout: flowLayout)
        return collectionView
    }()

    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        dataSource?.loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startObserveKeyboardNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopObserveKeyboardNotifications()
    }

    // MARK: - PresenterOutput
    func render(state: ViewStateProtocol) {
        guard let state = state as? CharacterViewState else { return }
        collectionViewDataSource.isLoading = state.isLoading
        collectionViewDataSource.data = state.data
        //TODO error handling
    }

    // MARK: - private methods
    private func setupViews() {
        title = "Marvel"

        navigationItem.hidesSearchBarWhenScrolling = true

        setupCollectionView()
        setupSearchController()
    }

    private func setupCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        setupConstraints()
        collectionViewDataSource.collectionView = collectionView
        collectionView.delegate = self
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupConstraints() {
        guard let margins = view else { return }
        NSLayoutConstraint.activate([
            collectionView
                .leadingAnchor
                .constraint(equalTo: margins.leadingAnchor),
            collectionView
                .trailingAnchor
                .constraint(equalTo: margins.trailingAnchor),
            collectionView
                .topAnchor
                .constraint(equalTo: margins.topAnchor),
            collectionView
                .bottomAnchor
                .constraint(equalTo: margins.bottomAnchor)
        ])
    }

    private func startObserveKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter
            .addObserver(self,
                         selector: #selector(adjustForKeyboard),
                         name: Notification.Name.UIKeyboardWillShow,
                         object: nil)
        notificationCenter
            .addObserver(self,
                         selector: #selector(adjustForKeyboard),
                         name: Notification.Name.UIKeyboardWillHide,
                         object: nil)
    }

    private func stopObserveKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!

        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = collectionView.convert(keyboardScreenEndFrame, from: view.window)
        let duration: TimeInterval = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval

        var contentInset = UIEdgeInsets.zero
        if notification.name == Notification.Name.UIKeyboardWillShow {
            contentInset.bottom = keyboardViewEndFrame.height
        }

        UIView.animate(withDuration: duration) { [weak self] in
            self?.collectionView.contentInset = contentInset
            self?.collectionView.scrollIndicatorInsets = contentInset
        }
    }
}

extension CharacterCollectionView: UICollectionViewDelegate {
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let characterId = collectionViewDataSource.data?[indexPath.row].id else { return }
        router?.route(to: .characterDetails(characterId))
    }
}

extension CharacterCollectionView: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
            !query.isEmpty || !searchController.isActive else { return }
        dataSource?.search(query: query)
    }
}
