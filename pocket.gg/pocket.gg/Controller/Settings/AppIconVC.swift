//
//  AppIconVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-05-31.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class AppIconVC: UITableViewController {

  private var alternateAppIconUsed: Bool

  private let primaryIconCell: UITableViewCell = {
    let cell = UITableViewCell()
    cell.textLabel?.text = "Default"
    guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
          let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
          let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
          let lastIcon = iconFiles.last else { return cell }
    cell.imageView?.image = UIImage(named: lastIcon)
    cell.imageView?.layer.cornerRadius = 9
    cell.imageView?.layer.masksToBounds = true

    cell.imageView?.setEdgeConstraints(
      top: cell.contentView.topAnchor,
      bottom: cell.contentView.bottomAnchor,
      leading: cell.contentView.leadingAnchor,
      padding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 0)
    )
    return cell
  }()

  private let alternateIconCell: UITableViewCell = {
    let cell = UITableViewCell()
    cell.textLabel?.text = "Alternate"
    guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
          let altIconsDictionary = iconsDictionary["CFBundleAlternateIcons"] as? [String: Any],
          let alternateAppIcon = altIconsDictionary["alternateAppIcon"] as? [String: Any],
          let iconFiles = alternateAppIcon["CFBundleIconFiles"] as? [String],
          let lastIcon = iconFiles.last else { return cell }
    cell.imageView?.image = UIImage(named: lastIcon)
    cell.imageView?.layer.cornerRadius = 9
    cell.imageView?.layer.masksToBounds = true
    cell.imageView?.setEdgeConstraints(
      top: cell.contentView.topAnchor,
      bottom: cell.contentView.bottomAnchor,
      leading: cell.contentView.leadingAnchor,
      padding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 0)
    )
    return cell
  }()

  // MARK: Initialization

  init() {
    alternateAppIconUsed = UserDefaults.standard.bool(forKey: k.UserDefaults.alternateAppIconUsed)
    super.init(style: .insetGrouped)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "App Icon"
  }

  // MARK: Table View Data Source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      primaryIconCell.accessoryType = alternateAppIconUsed ? .none : .checkmark
      return primaryIconCell
    case 1:
      alternateIconCell.accessoryType = alternateAppIconUsed ? .checkmark : .none
      return alternateIconCell
    default: return UITableViewCell()
    }
  }

  // MARK: Table View Delegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch indexPath.row {
    case 0:
      UIApplication.shared.setAlternateIconName(nil)
      alternateAppIconUsed = false
      UserDefaults.standard.set(false, forKey: k.UserDefaults.alternateAppIconUsed)
      tableView.reloadData()
    case 1:
      UIApplication.shared.setAlternateIconName("alternateAppIcon")
      alternateAppIconUsed = true
      UserDefaults.standard.set(true, forKey: k.UserDefaults.alternateAppIconUsed)
      tableView.reloadData()
    default: return
    }
  }
}
