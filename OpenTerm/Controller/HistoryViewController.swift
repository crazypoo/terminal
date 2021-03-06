//
//  HistoryViewController.swift
//  OpenTerm
//
//  Created by Louis D'hauwe on 02/01/2018.
//  Copyright © 2018 Silver Fox. All rights reserved.
//

import UIKit
import PanelKit

protocol HistoryViewControllerDelegate: class {

	func didSelectCommand(command: String)

}

class HistoryViewController: UIViewController {

	var commands = [String]()

	weak var delegate: HistoryViewControllerDelegate?

	@IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "History"
		self.view.tintColor = .defaultMainTintColor
		self.navigationController?.navigationBar.barStyle = .blackTranslucent

		// Remove separators beyond content
		self.tableView.tableFooterView = UIView()

		tableView.dataSource = self
		tableView.delegate = self

    }

	func addCommand(_ command: String) {

		tableView.performBatchUpdates({

			self.commands.append(command)
			self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)

		}, completion: nil)

	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

}

extension HistoryViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return commands.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")

		cell.backgroundColor = self.view.backgroundColor
		cell.textLabel?.text = commands.reversed()[indexPath.row]
		cell.textLabel?.textColor = .white
		cell.textLabel?.font = UIFont(name: "Menlo", size: 16)

		return cell
	}

}

extension HistoryViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)

		let commandSelected = commands.reversed()[indexPath.row]
		delegate?.didSelectCommand(command: commandSelected)

		if let panelVC = self.panelNavigationController?.panelViewController {
			if panelVC.isFloating == false {
				self.dismiss(animated: true, completion: nil)
			}
		}
	}

}

extension HistoryViewController: PanelContentDelegate {

	var preferredPanelContentSize: CGSize {
		return CGSize(width: 320, height: 480)
	}

	var minimumPanelContentSize: CGSize {
		return CGSize(width: 320, height: 320)
	}

	var maximumPanelContentSize: CGSize {
		return CGSize(width: 600, height: 800)
	}

}

extension HistoryViewController: PanelStateCoder {

	var panelId: Int {
		return 1
	}

}
