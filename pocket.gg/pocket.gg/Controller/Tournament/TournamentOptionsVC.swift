//
//  TournamentOptionsVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-07-29.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class TournamentOptionsVC: UITableViewController {

    let pinned: Bool
    let pinnedLimitReached: Bool
    let tournamentSlug: String?
    let tournamentOrganizerName: String?
    let tournamentOrganizerPrefix: String?
    
    var tournamentWasPinned: (() -> Void)?
    var moreTournamentsByTO: (() -> Void)?
    
    // MARK: - Initialization
    
    init(pinned: Bool, pinnedLimitReached: Bool, slug: String?, name: String?, prefix: String?) {
        self.pinned = pinned
        self.pinnedLimitReached = pinnedLimitReached
        self.tournamentSlug = slug
        self.tournamentOrganizerName = name
        self.tournamentOrganizerPrefix = prefix
        super.init(style: .insetGrouped)
        title = "Options"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dismissVC))
    }
    
    // MARK: - Actions
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 { return 2 }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 2 else { return nil }
        return "Tournament Organizer"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard section == 0 else { return nil }
        if pinnedLimitReached, !pinned {
            return k.Error.pinnedTournamentLimit
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell()
            cell.imageView?.image = UIImage(systemName: pinned ? "pin.slash.fill" : "pin.fill")
            if pinnedLimitReached, !pinned {
                cell.imageView?.tintColor = .systemGray
                return cell.setupDisabled("Pin this tournament")
            }
            cell.textLabel?.text = pinned ? "Unpin this tournament" : "Pin this tournament"
            cell.textLabel?.textColor = .systemRed
            
            return cell
        case 1:
            let cell = UITableViewCell()
            cell.imageView?.image = UIImage(systemName: "square.and.arrow.up")
            cell.textLabel?.text = "Share this tournament"
            cell.textLabel?.textColor = .systemRed
            cell.isUserInteractionEnabled = tournamentSlug != nil
            cell.imageView?.tintColor = tournamentSlug != nil ? .systemRed : .systemGray
            cell.textLabel?.isEnabled = tournamentSlug != nil
            return cell
        case 2:
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell()
                cell.selectionStyle = .none
                cell.imageView?.image = UIImage(systemName: "person.fill")
                cell.imageView?.tintColor = .label
                let entrant = Entrant(id: nil, name: tournamentOrganizerName, teamName: tournamentOrganizerPrefix)
                cell.textLabel?.attributedText = SetUtilities.getAttributedEntrantText(entrant, bold: false,
                                                                                       size: cell.textLabel?.font.pointSize ?? 10,
                                                                                       teamNameLength: tournamentOrganizerPrefix?.count)
                return cell
            case 1:
                let cell = UITableViewCell().setupActive(textColor: .systemRed, text: "More tournaments by this tournament organizer")
                cell.textLabel?.numberOfLines = 0
                return cell
            default: break
            }
        default: break
        }
        return UITableViewCell()
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0, let tournamentWasPinned = tournamentWasPinned {
            dismiss(animated: true) { tournamentWasPinned() }
            return
        }
        if indexPath.section == 1 {
            guard let slug = tournamentSlug, let url = URL(string: "https://smash.gg/\(slug)") else { return }
            let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(ac, animated: true)
        }
        if indexPath.section == 2, indexPath.row == 1, let moreTournamentsByTO = moreTournamentsByTO {
            dismiss(animated: true) { moreTournamentsByTO() }
            return
        }
    }
}
