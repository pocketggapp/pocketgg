//
//  AboutVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-02-26.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

final class AboutVC: UITableViewController {

    var aboutInfoCell = AboutInfoCell()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About"
    }
    
    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 4: return 1
        case 2: return 2
        case 3: return 3
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 { return AboutInfoCell() }
        case 1:
            let cell = UITableViewCell()
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "smash.gg GraphQL API"
            return cell
        case 2:
            let cell = UITableViewCell()
            cell.accessoryType = .disclosureIndicator
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Support"
                return cell
            case 1:
                cell.textLabel?.text = "Twitter"
                return cell
            default: break
            }
        case 3:
            let cell = UITableViewCell()
            cell.accessoryType = .disclosureIndicator
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Apollo iOS"
                return cell
            case 1:
                cell.textLabel?.text = "GRDB"
                return cell
            case 2:
                cell.textLabel?.text = "Firebase"
                return cell
            default: break
            }
        case 4:
            let cell = UITableViewCell()
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "Privacy Policy"
            return cell
        default: break
        }
        return UITableViewCell()
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 2: return "Contact"
        case 3: return "Libraries Used"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            guard let url = URL(string: k.URL.smashggAPI) else { break }
            present(SFSafariViewController(url: url), animated: true)
        case 2:
            switch indexPath.row {
            case 0:
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([k.Mail.address])
                    mail.setSubject("pocket.gg Support Request")
                    mail.setMessageBody(k.Mail.supportRequest, isHTML: false)
                    present(mail, animated: true)
                } else {
                    let alert = UIAlertController(title: "Support", message: k.Mail.supportRequestFallback, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    present(alert, animated: true)
                }
            case 1:
                guard let url = URL(string: k.URL.twitter) else { break }
                UIApplication.shared.open(url)
            default: break
            }
        case 3:
            switch indexPath.row {
            case 0:
                guard let url = URL(string: k.URL.apolloiOS) else { break }
                present(SFSafariViewController(url: url), animated: true)
            case 1:
                guard let url = URL(string: k.URL.grdb) else { break }
                present(SFSafariViewController(url: url), animated: true)
            case 2:
                guard let url = URL(string: k.URL.firebase) else { break }
                present(SFSafariViewController(url: url), animated: true)
            default: break
            }
        case 4:
            guard let url = URL(string: k.URL.privacyPolicy) else { break }
            present(SFSafariViewController(url: url), animated: true)
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 100 : UITableView.automaticDimension
    }
}

extension AboutVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
