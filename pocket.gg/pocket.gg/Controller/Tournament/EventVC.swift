//
//  EventVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-03-15.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit
import SafariServices

final class EventVC: UITableViewController {
    
    var event: Event
    var doneRequest = false
    var requestSuccessful = true
    
    var lastRefreshTime: Date?
    
    var IDs: TournamentIDs
    
    // MARK: - Initialization
    
    init(_ event: Event, IDs: TournamentIDs) {
        self.event = event
        self.IDs = IDs
        self.IDs.eventID = event.id
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = event.name
        tableView.register(Value1Cell.self, forCellReuseIdentifier: k.Identifiers.value1Cell)
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        loadEventDetails()
    }
    
    private func loadEventDetails() {
        guard let id = event.id else {
            doneRequest = true
            requestSuccessful = false
            refreshControl?.endRefreshing()
            tableView.reloadData()
            return
        }
        TournamentDetailsService.getEvent(id) { [weak self] (result) in
            guard let result = result else {
                self?.doneRequest = true
                self?.requestSuccessful = false
                self?.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
                return
            }
            
            self?.event.phases = result["phases"] as? [Phase]
            self?.event.topStandings = result["topStandings"] as? [Standing]
            
            self?.doneRequest = true
            self?.requestSuccessful = true
            self?.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc private func refreshData() {
        if let lastRefreshTime = lastRefreshTime {
            // Don't allow refreshing more than once every 5 seconds
            guard Date().timeIntervalSince(lastRefreshTime) > 5 else {
                refreshControl?.endRefreshing()
                return
            }
        }
        
        lastRefreshTime = Date()
        loadEventDetails()
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1:
            guard doneRequest, requestSuccessful else { return 1 }
            guard let phases = event.phases, !phases.isEmpty else { return 1 }
            return phases.count
        case 2:
            guard doneRequest, requestSuccessful else { return 1 }
            guard let standings = event.topStandings, !standings.isEmpty else { return 1 }
            guard standings.count > 8 else { return standings.count }
            return 9
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = SubtitleCell()
            
            // Text Label
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: k.Sizes.largeFont)
            
            // Detail Text Label
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            cell.detailTextLabel?.numberOfLines = 0
            
            var detailText = ""
            if let eventType = event.eventType {
                switch eventType {
                case 1: detailText = "Singles"
                case 2: detailText = "Doubles"
                case 5: detailText = "Teams"
                default: break
                }
            }
            if event.eventType != nil && event.videogameName != nil {
                detailText += " • "
            }
            if let videogameName = event.videogameName {
                detailText += videogameName
            }
            detailText += "\n"
            let dotPosition = detailText.count
            
            detailText += "● "
            detailText += DateFormatter.shared.dateFromTimestamp(event.startDate)
            
            let dotColor: UIColor
            switch event.state ?? "" {
            case "ACTIVE": dotColor = .systemGreen
            case "COMPLETED": dotColor = .systemGray
            default: dotColor = .systemBlue
            }
            
            let attributedDetailText = NSMutableAttributedString(string: detailText)
            attributedDetailText.addAttribute(.foregroundColor, value: dotColor, range: NSRange(location: dotPosition, length: 1))
            
            cell.selectionStyle = .none
            cell.imageView?.image = UIImage(named: "game-controller")
            cell.updateView(text: event.name, imageInfo: event.videogameImage, detailText: nil, newRatio: k.Sizes.eventImageRatio)
            cell.detailTextLabel?.attributedText = attributedDetailText
            
            return cell
            
        case 1:
            guard doneRequest else { return LoadingCell() }
            guard requestSuccessful, let phases = event.phases else { return UITableViewCell().setupDisabled(k.Message.errorLoadingBrackets) }
            guard !phases.isEmpty else { return UITableViewCell().setupDisabled(k.Message.noBrackets) }
            guard let phase = phases[safe: indexPath.row] else { break }
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.value1Cell, for: indexPath) as? Value1Cell {
                cell.accessoryType = .disclosureIndicator
                cell.updateLabels(text: phase.name, detailText: phase.state?.capitalized)
                return cell
            }
            
        case 2:
            guard doneRequest else { return LoadingCell() }
            guard requestSuccessful, let standings = event.topStandings else { return UITableViewCell().setupDisabled(k.Message.errorLoadingStandings) }
            guard !standings.isEmpty else { return UITableViewCell().setupDisabled(k.Message.noStandings) }
            
            if indexPath.row == 8 {
                return UITableViewCell().setupActive(textColor: .systemRed, text: "View all standings")
            }
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.value1Cell, for: indexPath) as? Value1Cell {
                guard let standing = standings[safe: indexPath.row] else { break }
                
                let name: String
                let teamNameLength: Int
                if let teamName = standing.entrant?.teamName, let entrantName = standing.entrant?.name {
                    name = teamName + " " + entrantName
                    teamNameLength = teamName.count
                } else if let entrantName = standing.entrant?.name {
                    name = entrantName
                    teamNameLength = 0
                } else {
                    name = ""
                    teamNameLength = 0
                }
                
                guard let placementNum = standing.placement else {
                    let attributedText = NSMutableAttributedString(string: name)
                    attributedText.addAttribute(.foregroundColor,
                                                value: UIColor.systemGray,
                                                range: NSRange(location: 0, length: teamNameLength))
                    cell.updateLabels(attributedText: attributedText, detailText: nil)
                    return cell
                }
                
                let placement: String
                switch placementNum {
                case 0: placement = ""
                case 1: placement = "🥇 "
                case 2: placement = "🥈 "
                case 3: placement = "🥉 "
                default: placement = " \(placementNum):  "
                }
                cell.selectionStyle = .none
                
                // placement needs to be converted to NSString to get the correct length for when there is an emoji
                let attributedText = NSMutableAttributedString(string: placement + name)
                attributedText.addAttribute(.foregroundColor,
                                            value: UIColor.systemGray,
                                            range: NSRange(location: (placement as NSString).length, length: teamNameLength))
                cell.updateLabels(attributedText: attributedText, detailText: nil)
                return cell
            }
        default: break
        }
        return UITableViewCell()
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Summary"
        case 1: return "Brackets"
        case 2: return "Standings"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            guard let phase = event.phases?[safe: indexPath.row] else {
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            let numPhaseGroups = phase.numPhaseGroups ?? 1
            if numPhaseGroups > 1 {
                // If there are multiple phase groups, then proceed to PhaseGroupListViewController as normal
                navigationController?.pushViewController(PhaseGroupListVC(phase: phase, IDs: IDs), animated: true)
            } else if numPhaseGroups == 1 {
                // If there is only 1 phase group, jump straight to PhaseGroupVC. The singular phase group's ID will be obtained using the phase's ID
                navigationController?.pushViewController(PhaseGroupVC(nil, phase.id ?? nil, title: phase.name, IDs: IDs), animated: true)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        case 2:
            guard indexPath.row == 8 else { return }
            navigationController?.pushViewController(StandingsVC(event.topStandings ?? [], eventID: event.id), animated: true)
        default:
            return
        }
    }
}
