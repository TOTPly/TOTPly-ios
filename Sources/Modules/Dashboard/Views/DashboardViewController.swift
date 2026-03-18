//
//  DashboardViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 17.03.2026.
//

import UIKit

final class DashboardViewController: UIViewController {
    var presenter: DashboardPresenter?

    private var listManager: DashboardListManager?

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 72
        return tv
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        return ai
    }()

    private let emptyLabel: UILabel = {
        let l = UILabel()
        l.text = "Нет TOTP-кодов"
        l.font = .systemFont(ofSize: 17, weight: .medium)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        l.isHidden = true
        return l
    }()

    private let errorView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isHidden = true
        return sv
    }()

    private let errorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .regular)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    private let retryButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Повторить", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Dashboard"

        setupNavigationBar()
        setupUI()
        setupSearchController()
        setupRefreshControl()

        listManager = DashboardListManager(tableView: tableView)
        listManager?.onItemSelected = { [weak self] index in
            self?.presenter?.didTapItem(at: index)
        }
        listManager?.onItemDeleted = { [weak self] itemId in
            self?.presenter?.didTapDelete(itemId: itemId)
        }
        listManager?.onItemCopyCode = { [weak self] itemId in
            self?.presenter?.didTapCopyCode(itemId: itemId)
        }

        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }

    private func setupNavigationBar() {
        let refreshButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(didTapForceRefresh)
        )
        let maskButton = UIBarButtonItem(
            image: UIImage(systemName: "eye.slash"),
            style: .plain,
            target: self,
            action: #selector(didTapToggleMask)
        )
        navigationItem.rightBarButtonItems = [refreshButton, maskButton]

        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(didTapProfile))
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(didTapSettings))
        navigationItem.leftBarButtonItems = [profileButton, settingsButton]
    }

    private func setupUI() {
        errorView.addArrangedSubview(errorLabel)
        errorView.addArrangedSubview(retryButton)
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)

        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyLabel)
        view.addSubview(errorView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])
    }

    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func applyState(_ loadingState: LoadingState, isEmpty: Bool) {
        switch loadingState {
        case .initial, .loading:
            activityIndicator.startAnimating()
            tableView.isHidden = true
            emptyLabel.isHidden = true
            errorView.isHidden = true

        case .loaded:
            activityIndicator.stopAnimating()
            if isEmpty {
                tableView.isHidden = true
                emptyLabel.isHidden = false
            } else {
                tableView.isHidden = false
                emptyLabel.isHidden = true
            }
            errorView.isHidden = true

        case .error(let error):
            activityIndicator.stopAnimating()
            tableView.isHidden = true
            emptyLabel.isHidden = true
            errorView.isHidden = false
            errorLabel.text = error.localizedDescription
        }
    }

    private var currentState: DashboardViewState?

    @objc private func didTapProfile() {
        presenter?.didTapProfile()
    }

    @objc private func didTapSettings() {
        presenter?.didTapSettings()
    }

    @objc private func didTapToggleMask() {
        presenter?.didTapToggleCodeMask()
    }

    @objc private func didTapForceRefresh() {
        presenter?.didTapForceRefresh()
    }

    @objc private func didTapRetry() {
        presenter?.didPullToRefresh()
    }

    @objc private func didPullToRefresh() {
        presenter?.didPullToRefresh()
    }
}

extension DashboardViewController: DashboardView {
    func render(_ state: DashboardViewState) {
        currentState = state

        let cellViewModels = state.displayItems.map {
            TOTPCellModel.from(item: $0, masked: state.areCodesMasked)
        }

        listManager?.update(items: cellViewModels)
        applyState(state.loadingState, isEmpty: state.displayItems.isEmpty)

        if !state.isRefreshing {
            tableView.refreshControl?.endRefreshing()
        }

        if let maskButton = navigationItem.rightBarButtonItems?.last {
            let iconName = state.areCodesMasked ? "eye" : "eye.slash"
            maskButton.image = UIImage(systemName: iconName)
        }
    }

    func copyCodeToClipboard(_ code: String) {
        UIPasteboard.general.string = code
        showCopiedToast()
    }

    private func showCopiedToast() {
        let toast = UILabel()
        toast.text = "Скопировано"
        toast.font = .systemFont(ofSize: 14, weight: .medium)
        toast.textColor = .white
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toast.textAlignment = .center
        toast.layer.cornerRadius = 16
        toast.clipsToBounds = true
        toast.translatesAutoresizingMaskIntoConstraints = false
        toast.alpha = 0

        view.addSubview(toast)
        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            toast.widthAnchor.constraint(equalToConstant: 140),
            toast.heightAnchor.constraint(equalToConstant: 32),
        ])

        UIView.animate(withDuration: 0.2, animations: {
            toast.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.8, options: [], animations: {
                toast.alpha = 0
            }) { _ in
                toast.removeFromSuperview()
            }
        }
    }
}

extension DashboardViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        presenter?.didSearch(query: query)
    }
}
