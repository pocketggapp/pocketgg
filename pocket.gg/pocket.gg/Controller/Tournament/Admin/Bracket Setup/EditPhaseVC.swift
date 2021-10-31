//
//  EditPhaseVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-09-01.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class EditPhaseVC: UITableViewController {
    
    let eventID: Int?
    let phase: AdminPhase?
    
    let nameTextField = UITextField()
    let phaseTypeTextField = UITextField()
    let numGroupsTextField = UITextField()
    let phaseTypes: [String]
    
    var nameTextEdited = false
    var numGroupsEdited = false
    var nameTextIsValid: Bool {
        guard let numCharacters = nameTextField.text?.count else { return true }
        return numCharacters > 0 && numCharacters <= 64
    }
    var numGroupsIsValid: Bool {
        guard let text = numGroupsTextField.text else { return true }
        guard let numGroups = Int(text) else { return false }
        return numGroups > 0 && numGroups <= 512
    }
    
    var doneRequest = true
    let loadingView = LoadingView()
    var phaseEdited: (() -> Void)?
    
    // MARK: - Initialization
    
    init(eventID: Int?, phase: AdminPhase?) {
        self.eventID = eventID
        self.phase = phase
        phaseTypes = ["Single Elimination", "Double Elimination", "Round Robin", "Swiss", "Custom Schedule", "Matchmaking", "Elimination Rounds"]
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = phase?.name {
            title = "Edit \(name)"
        } else {
            title = "New Phase"
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        isModalInPresentation = true
        tableView.keyboardDismissMode = .onDrag
        
        view.addSubview(loadingView)
        loadingView.setAxisConstraints(xAnchor: view.centerXAnchor, yAnchor: view.centerYAnchor)
        loadingView.isHidden = true
        
        setupFields()
    }
    
    private func setupFields() {
        nameTextField.placeholder = "Name"
        phaseTypeTextField.placeholder = "Phase Type"
        numGroupsTextField.placeholder = "Number of Pools"
        
        guard let phase = phase else { return }
        nameTextField.text = phase.name
        phaseTypeTextField.text = phase.bracketType?.replacingOccurrences(of: "_", with: " ").capitalized
        if let numGroups = phase.numGroups {
            numGroupsTextField.text = "\(numGroups)"
        }
    }
    
    // MARK: - Actions
    
    @objc private func cancel() {
        guard let nameText = nameTextField.text, nameText.isEmpty,
              let phaseTypeText = phaseTypeTextField.text, phaseTypeText.isEmpty,
              let numGroupsText = numGroupsTextField.text, numGroupsText.isEmpty else {
            let alert = UIAlertController(title: "", message: "Are you sure you want to discard this new Phase?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Keep Editing", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Discard Changes", style: .destructive, handler: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }))
            // Make the presentation a popover for iPads
            alert.modalPresentationStyle = .popover
            if let popController = alert.popoverPresentationController {
                popController.barButtonItem = navigationItem.leftBarButtonItem
            }
            present(alert, animated: true)
            return
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func done() {
        guard doneRequest else { return }
        
        guard let nameText = nameTextField.text, !nameText.isEmpty,
              let phaseTypeText = phaseTypeTextField.text, !phaseTypeText.isEmpty,
              let numGroupsText = numGroupsTextField.text, !numGroupsText.isEmpty else {
            let alert = UIAlertController(title: "Cannot create Phase", message: "Please fill in all fields before continuing", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        var bracketType: BracketType?
        switch phaseTypeText {
        case "Single Elimination": bracketType = .singleElimination
        case "Double Elimination": bracketType = .doubleElimination
        case "Round Robin":        bracketType = .roundRobin
        case "Swiss":              bracketType = .swiss
        case "Custom Schedule":    bracketType = .customSchedule
        case "Matchmaking":        bracketType = .matchmaking
        case "Elimination Rounds": bracketType = .eliminationRounds
        default: break
        }
        guard nameTextIsValid, numGroupsIsValid,
              let bracketType = bracketType,
              let numGroups = Int(numGroupsText) else {
            let alert = UIAlertController(title: "Cannot create Phase", message: "Please resolve all errors before continuing", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
        doneRequest = false
        loadingView.isHidden = false
        let newPhase = NewPhase(name: nameText, numPhaseGroups: numGroups, bracketType: bracketType)
        if let phaseID = phase?.id {
            TournamentMutationsService.updatePhase(phaseID: phaseID, newPhase: newPhase) { [weak self] success, error in
                self?.loadingView.isHidden = true
                self?.doneRequest = true
                if let error = error {
                    self?.presentPhaseSaveErrorAlert(error: error)
                    return
                }
                guard success else {
                    self?.presentPhaseSaveErrorAlert()
                    return
                }
                
                let alert = UIAlertController(title: "Success", message: "\(nameText) successfully updated", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        } else {
            TournamentMutationsService.createPhase(eventID: eventID, newPhase: newPhase) { [weak self] phaseID, error in
                self?.loadingView.isHidden = true
                self?.doneRequest = true
                if let error = error {
                    self?.presentPhaseSaveErrorAlert(error: error)
                    return
                }
                guard phaseID != nil else {
                    self?.presentPhaseSaveErrorAlert()
                    return
                }

                if let phaseEdited = self?.phaseEdited {
                    self?.dismiss(animated: true) { phaseEdited() }
                }
            }
        }
    }
    
    private func presentPhaseSaveErrorAlert(_ errorMessage: String? = nil, error: Error? = nil) {
        let message: String
        if let error = error {
            message = error.localizedDescription
        } else {
            message = errorMessage ?? "The phase was unable to be saved. Please check your internet connection and try again."
        }
        let alert = UIAlertController(title: "Cannot save Phase", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func presentPhaseDeleteErrorAlert(_ error: Error? = nil) {
        let message: String
        if let error = error {
            message = error.localizedDescription
        } else {
            message = "The phase was unable to be deleted. Please check your internet connection and try again."
        }
        let alert = UIAlertController(title: "Error deleting Phase", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true)
    }

    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return phase != nil ? 4 : 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Name"
        case 1: return "Phase Type"
        case 2: return "Number of Pools"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            guard nameTextEdited else { return nil }
            guard let text = nameTextField.text else { return nil }
            guard !text.isEmpty else { return "Name is required" }
            guard text.count <= 64 else { return "Name cannot be longer than 64 characters" }
            return nil
        case 2:
            guard numGroupsEdited else { return nil }
            guard let text = numGroupsTextField.text else { return nil }
            guard !text.isEmpty else { return "Number of pools is required" }
            guard let numGroups = Int(text) else { return "Invalid number of pools" }
            guard numGroups > 0 else { return "Number of pools is required" }
            guard numGroups <= 512 else { return "Number of pools cannot exceed 512" }
            return nil
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let textField: UITextField
        switch indexPath.section {
        case 0:
            textField = nameTextField
            textField.tag = 0
            textField.delegate = self
        case 1:
            textField = phaseTypeTextField
            textField.tag = 1
            textField.delegate = self
            let pickerView = UIPickerView()
            pickerView.dataSource = self
            pickerView.delegate = self
            textField.inputView = pickerView
        case 2:
            textField = numGroupsTextField
            textField.tag = 2
            textField.delegate = self
            textField.keyboardType = .numberPad
        case 3:
            cell.textLabel?.text = "Remove Phase"
            cell.textLabel?.textColor = .systemRed
            return cell
        default: return UITableViewCell()
        }
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.adjustsFontForContentSizeCategory = true
        cell.contentView.addSubview(textField)
        textField.setEdgeConstraints(top: cell.contentView.topAnchor, bottom: cell.contentView.bottomAnchor,
                                     leading: cell.contentView.leadingAnchor, trailing: cell.contentView.trailingAnchor,
                                     padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 3 else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        if let phase = phase {
            let message: String
            if let name = phase.name {
                message = "Are you sure you want to delete Phase \(name)?"
            } else {
                message = "Are you sure you want to delete this phase?"
            }
            let alert = UIAlertController(title: "Delete Phase", message: message, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                guard let id = phase.id else {
                    self?.presentPhaseDeleteErrorAlert()
                    return
                }
                TournamentMutationsService.deletePhase(id) { [weak self] success, error in
                    if let error = error {
                        self?.presentPhaseDeleteErrorAlert(error)
                        return
                    }
                    guard success else {
                        self?.presentPhaseDeleteErrorAlert()
                        return
                    }
                    if let phaseEdited = self?.phaseEdited {
                        phaseEdited()
                    }
                }
            }))
            // Make the presentation a popover for iPads
            alert.modalPresentationStyle = .popover
            if let popController = alert.popoverPresentationController {
                popController.sourceRect = tableView.rectForRow(at: indexPath)
                popController.sourceView = tableView
            }
            present(alert, animated: true)
        }
    }
}

// MARK: - Text Field Delegate

extension EditPhaseVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.tag != 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            if nameTextIsValid {
                nameTextField.rightViewMode = .never
                nameTextField.rightView = nil
            } else {
                nameTextField.rightViewMode = .unlessEditing
                let imageView = UIImageView(image: UIImage(systemName: "multiply"))
                imageView.contentMode = .scaleAspectFit
                nameTextField.rightView = imageView
            }
            nameTextEdited = true
            tableView.reloadSections([0], with: .none)
        case 2:
            if numGroupsIsValid {
                numGroupsTextField.rightViewMode = .never
                numGroupsTextField.rightView = nil
            } else {
                numGroupsTextField.rightViewMode = .unlessEditing
                let imageView = UIImageView(image: UIImage(systemName: "multiply"))
                imageView.contentMode = .scaleAspectFit
                numGroupsTextField.rightView = imageView
            }
            numGroupsEdited = true
            tableView.reloadSections([2], with: .none)
        default: return
        }
    }
}

// MARK: - Picker View Data Source & Delegate

extension EditPhaseVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return phaseTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return phaseTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        phaseTypeTextField.text = phaseTypes[row]
        // Matchmaking and Elimination Rounds phases only support 1 pool
        if row == 5 || row == 6 {
            numGroupsTextField.text = "1"
            numGroupsTextField.rightViewMode = .never
            numGroupsTextField.rightView = nil
            numGroupsTextField.isEnabled = false
            numGroupsTextField.textColor = .systemGray
            tableView.reloadSections([2], with: .none)
        } else {
            numGroupsTextField.isEnabled = true
            numGroupsTextField.textColor = .label
        }
    }
}
