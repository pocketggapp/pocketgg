//
//  EditPinnedTournamentsVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-06-15.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class EditPinnedTournamentsVC: UITableViewController {
    
    var pinnedTournaments: [Tournament]
    var pinnedTournamentsEdited: Bool
    
    var applyChanges: (([Tournament]) -> Void)?
    
    // MARK: - Initialization
    
    init(_ pinnedTournaments: [Tournament]) {
        self.pinnedTournaments = pinnedTournaments
        pinnedTournamentsEdited = false
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TournamentListCell.self, forCellReuseIdentifier: k.Identifiers.tournamentListCell)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorColor = .clear
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(saveChanges))
        
        setEditing(true, animated: false)
    }
    
    // MARK: - Actions
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveChanges() {
        if pinnedTournamentsEdited {
            MainVCDataService.updatePinnedTournamentIDs(pinnedTournaments)
            if let applyChanges = applyChanges {
                dismiss(animated: true) { [weak self] in
                    guard let tournaments = self?.pinnedTournaments else { return }
                    applyChanges(tournaments)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pinnedTournaments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.tournamentListCell, for: indexPath) as? TournamentListCell {
            guard let tournament = pinnedTournaments[safe: indexPath.row] else {
                return UITableViewCell()
            }
            
            cell.tag = indexPath.row
            cell.backgroundColor = .systemGroupedBackground
            cell.selectionStyle = .none
            cell.imageView?.image = UIImage(named: "placeholder")
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.numberOfLines = 2
            var detailText = tournament.date ?? ""
            detailText += tournament.isOnline ?? true ? "\nOnline" : ""
            
            cell.textLabel?.text = tournament.name
            cell.detailTextLabel?.text = detailText
            
            cell.imageView?.layer.cornerRadius = k.Sizes.cornerRadius
            cell.imageView?.layer.masksToBounds = true
            let newSize = CGSize(width: k.Sizes.tournamentListCellHeight, height: k.Sizes.tournamentListCellHeight)
            ImageService.getImage(imageUrl: tournament.logoUrl, cache: .viewAllTournaments, newSize: newSize) { image in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    guard let imageView = cell.imageView else { return }
                    if cell.tag == indexPath.row {
                        UIView.transition(with: imageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                            cell.imageView?.image = image
                        }, completion: nil)
                    }
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedTournament = pinnedTournaments.remove(at: sourceIndexPath.row)
        pinnedTournaments.insert(movedTournament, at: destinationIndexPath.row)
        pinnedTournamentsEdited = true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pinnedTournaments.remove(at: indexPath.row)
            tableView.reloadData()
            pinnedTournamentsEdited = true
        }
    }
}
