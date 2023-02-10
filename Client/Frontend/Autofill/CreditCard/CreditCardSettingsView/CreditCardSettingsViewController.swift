// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import UIKit
import SwiftUI
import Storage
import Common
import Shared

class CreditCardSettingsViewController: UIViewController, Themeable {
    var themeObserver: NSObjectProtocol?
    var viewModel: CreditCardSettingsViewModel
    var startingConfig: CreditCardSettingsStartingConfig?
    var themeManager: ThemeManager
    var notificationCenter: NotificationProtocol

    // MARK: Views
    var creditCardEmptyView: UIHostingController<CreditCardSettingsEmptyView>
    var creditCardAddEditView: UIHostingController<CreditCardEditView>
    var creditCardTableViewController: CreditCardTableViewController

    // MARK: Initializers
    init(creditCardViewModel: CreditCardSettingsViewModel,
         startingConfig: CreditCardSettingsStartingConfig?,
         themeManager: ThemeManager = AppContainer.shared.resolve(),
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.startingConfig = startingConfig
        self.viewModel = creditCardViewModel
        self.themeManager = themeManager
        self.creditCardEmptyView = UIHostingController(rootView: CreditCardSettingsEmptyView())
        self.creditCardAddEditView =
        UIHostingController(rootView: CreditCardEditView(
            viewModel: viewModel.addEditViewModel,
            removeButtonColor: Color(themeManager.currentTheme.colors.textWarning),
            borderColor: Color(themeManager.currentTheme.colors.borderPrimary)))
        self.creditCardTableViewController = CreditCardTableViewController(viewModel: viewModel.creditCardTableViewModel)
        self.notificationCenter = notificationCenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        listenForThemeChange()
        applyTheme()
    }

    func viewSetup() {
        guard let emptyCreditCardView = creditCardEmptyView.view,
            let addEditCreditCardView = creditCardAddEditView.view,
            let creditCardTableView = creditCardTableViewController.view else { return }
        creditCardTableView.translatesAutoresizingMaskIntoConstraints = false
        emptyCreditCardView.translatesAutoresizingMaskIntoConstraints = false
        addEditCreditCardView.translatesAutoresizingMaskIntoConstraints = false

        addChild(creditCardEmptyView)
        addChild(creditCardAddEditView)
        addChild(creditCardTableViewController)
        view.addSubview(emptyCreditCardView)
        view.addSubview(addEditCreditCardView)
        view.addSubview(creditCardTableView)

        NSLayoutConstraint.activate([
            emptyCreditCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyCreditCardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            emptyCreditCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyCreditCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            addEditCreditCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addEditCreditCardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addEditCreditCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addEditCreditCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            creditCardTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            creditCardTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            creditCardTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            creditCardTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])

        // Hide all the views initially until we update the state
        hideAllViews()

        // Setup state and update view
        setupState()
    }

    func setupState() {
        // check if there are any starting config
        guard startingConfig == nil else {
            updateState(type: .empty)
            return
        }

        // Check if we have any credit cards to show in the list
        viewModel.listCreditCard { creditCards in
            guard let creditCards = creditCards, !creditCards.isEmpty else {
                DispatchQueue.main.async { [weak self] in
                    self?.updateState(type: .empty)
                }
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.viewModel.updateCreditCardsList(creditCards: creditCards)
                self?.updateState(type: .list)
            }
        }

        updateState(type: .edit)
    }

    func updateState(type: CreditCardSettingsState) {
        hideAllViews()
        switch type {
        case .empty:
            creditCardEmptyView.view.isHidden = false
        case .add:
            creditCardAddEditView.view.isHidden = false
        case .edit:
            creditCardAddEditView.view.isHidden = false
        case .list:
            creditCardTableViewController.reloadData()
            creditCardTableViewController.view.isHidden = false
        }
    }

    func hideAllViews() {
        creditCardEmptyView.view.isHidden = true
        creditCardAddEditView.view.isHidden = true
        creditCardTableViewController.view.isHidden = true
    }

    func applyTheme() {
        let theme = themeManager.currentTheme
        view.backgroundColor = theme.colors.layer1
    }

    deinit {
        notificationCenter.removeObserver(self)
    }
}