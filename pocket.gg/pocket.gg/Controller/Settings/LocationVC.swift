//
//  LocationVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-08-02.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class LocationVC: UITableViewController {

  private var countries: [String]
  private var states: [String]
  private var provinces: [String]

  private var selectedCountry: String
  private var selectedState: String
  private var usingSpecificCountry: Bool /// Reflects whether the option to use a specific country is enabled or not.
  private var usingSpecificState: Bool /// Reflects whether the option to use a specific state is enabled or not. If `canChooseState` is false, this is forced to also be false
  private var choosingCountry: Bool /// Reflects whether the country picker view is currently visible or not
  private var choosingState: Bool /// Reflects whether the state/province picker view is currently visible or not. If `canChooseState` is false, this is forced to also be false
  private var choosingUSStates: Bool /// Distinguishes between the user selecting states in the US or Canadian provinces
  private var canChooseState: Bool {
    return selectedCountry == "United States (US)" || selectedCountry == "Canada (CA)"
  }

  private var usingSpecificCountryCell: UITableViewCell
  private var countryPickerViewCell: UITableViewCell
  private let countryPickerView: UIPickerView

  private var usingSpecificStateCell: UITableViewCell
  private var statePickerViewCell: UITableViewCell
  private let statePickerView: UIPickerView
  private let specificStateSwitch: UISwitch

  /// Determines whether the VC can notify MainVC that the location was changed, and that the tournaments should be reloaded
  /// - Will be initialized to true whenever the view appears
  /// - When a setting is changed, the notification is sent, this is set to false, and is not set to true again until the view disappears
  private var canSendNotification: Bool

  // MARK: - Initialization

  init() {
    countries = ["-"]
    countries.append(contentsOf: NSLocale.isoCountryCodes.map {
      guard let countryName = Locale(identifier: "en_US").localizedString(forRegionCode: $0) else { return $0 }
      return "\(countryName) (\($0))"
    }.sorted())
    states = LocationVC.getStates()
    provinces = LocationVC.getProvinces()

    if let savedCountry = UserDefaults.standard.string(forKey: k.UserDefaults.selectedCountry), !savedCountry.isEmpty {
      selectedCountry = savedCountry
    } else {
      selectedCountry = "-"
    }
    if let savedState = UserDefaults.standard.string(forKey: k.UserDefaults.selectedState), !savedState.isEmpty {
      selectedState = savedState
    } else {
      selectedState = "-"
    }
    usingSpecificCountry = UserDefaults.standard.bool(forKey: k.UserDefaults.useSpecificCountry)
    usingSpecificState = UserDefaults.standard.bool(forKey: k.UserDefaults.useSpecificState)
    choosingCountry = false
    choosingState = false
    choosingUSStates = selectedCountry == "United States (US)"

    usingSpecificCountryCell = UITableViewCell()
    countryPickerViewCell = UITableViewCell()
    countryPickerView = UIPickerView()

    usingSpecificStateCell = UITableViewCell()
    statePickerViewCell = UITableViewCell()
    statePickerView = UIPickerView()
    specificStateSwitch = UISwitch()

    canSendNotification = true
    super.init(style: .insetGrouped)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Location"
    // Country
    countryPickerView.dataSource = self
    countryPickerView.delegate = self
    countryPickerView.tag = 0

    countryPickerViewCell.contentView.addSubview(countryPickerView)
    countryPickerView.setEdgeConstraints(
      top: countryPickerViewCell.contentView.topAnchor,
      bottom: countryPickerViewCell.contentView.bottomAnchor,
      leading: countryPickerViewCell.contentView.leadingAnchor,
      trailing: countryPickerViewCell.contentView.trailingAnchor
    )

    usingSpecificCountryCell.textLabel?.text = "Use specific country"
    usingSpecificCountryCell.selectionStyle = .none
    let specificCountrySwitch = UISwitch()
    specificCountrySwitch.isOn = usingSpecificCountry
    specificCountrySwitch.addTarget(self, action: #selector(countrySwitchToggled(_:)), for: .valueChanged)
    usingSpecificCountryCell.accessoryView = specificCountrySwitch

    // State/Province
    statePickerView.dataSource = self
    statePickerView.delegate = self
    statePickerView.tag = 1

    statePickerViewCell.contentView.addSubview(statePickerView)
    statePickerView.setEdgeConstraints(
      top: statePickerViewCell.contentView.topAnchor,
      bottom: statePickerViewCell.contentView.bottomAnchor,
      leading: statePickerViewCell.contentView.leadingAnchor,
      trailing: statePickerViewCell.contentView.trailingAnchor
    )

    usingSpecificStateCell.textLabel?.text = "Use specific state/province"
    usingSpecificStateCell.selectionStyle = .none
    specificStateSwitch.isOn = usingSpecificState
    specificStateSwitch.addTarget(self, action: #selector(stateSwitchToggled(_:)), for: .valueChanged)
    usingSpecificStateCell.accessoryView = specificStateSwitch
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    UserDefaults.standard.set(usingSpecificCountry, forKey: k.UserDefaults.useSpecificCountry)
    UserDefaults.standard.set(usingSpecificState, forKey: k.UserDefaults.useSpecificState)
    if selectedCountry == "-" || !usingSpecificCountry {
      UserDefaults.standard.removeObject(forKey: k.UserDefaults.selectedCountry)
    } else {
      UserDefaults.standard.set(selectedCountry, forKey: k.UserDefaults.selectedCountry)
    }
    if selectedState == "-" || !usingSpecificState || !usingSpecificCountry {
      UserDefaults.standard.removeObject(forKey: k.UserDefaults.selectedState)
    } else {
      UserDefaults.standard.set(selectedState, forKey: k.UserDefaults.selectedState)
    }
    canSendNotification = true
  }

  // MARK: Actions

  @objc private func countrySwitchToggled(_ sender: UISwitch) {
    usingSpecificCountry = sender.isOn
    if !usingSpecificCountry {
      choosingCountry = false
      specificStateSwitch.isOn = false
      usingSpecificState = false
      choosingState = false
    }
    tableView.reloadData()
    requestTournamentsReload()
  }

  @objc private func stateSwitchToggled(_ sender: UISwitch) {
    usingSpecificState = sender.isOn
    tableView.reloadData()
    requestTournamentsReload()
  }

  private func requestTournamentsReload() {
    if canSendNotification {
      NotificationCenter.default.post(name: Notification.Name(k.Notification.settingsChanged), object: nil)
      canSendNotification = false
    }
  }

  // MARK: - Table View Data Source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return usingSpecificCountry ? 2 : 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      guard usingSpecificCountry else { return 1 }
      return choosingCountry ? 3 : 2
    case 1:
      guard usingSpecificCountry else { return 0 }
      guard usingSpecificState else { return 1 }
      return choosingState ? 3 : 2
    default: return 0
    }

  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0: return "Country"
    case 1: return "State/Province"
    default: return nil
    }
  }

  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return section == 1 ? "Choosing a specific state/province is only supported for United States and Canada" : nil
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0: return usingSpecificCountryCell
      case 1:
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Country"
        cell.detailTextLabel?.textColor = choosingCountry ? .systemRed : .systemGray
        cell.detailTextLabel?.text = selectedCountry
        cell.detailTextLabel?.numberOfLines = 0
        return cell
      case 2: return countryPickerViewCell
      default: break
      }
    case 1:
      guard usingSpecificCountry else { break }
      switch indexPath.row {
      case 0:
        usingSpecificStateCell.isUserInteractionEnabled = canChooseState
        usingSpecificStateCell.textLabel?.isEnabled = canChooseState
        specificStateSwitch.isEnabled = canChooseState
        return usingSpecificStateCell
      case 1:
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = choosingUSStates ? "State" : "Province"
        cell.detailTextLabel?.textColor = choosingState ? .systemRed : .systemGray
        cell.detailTextLabel?.text = selectedState
        cell.detailTextLabel?.numberOfLines = 0
        cell.isUserInteractionEnabled = canChooseState
        return cell
      case 2:
        statePickerViewCell.isUserInteractionEnabled = canChooseState
        return statePickerViewCell
      default: break
      }
    default: break
    }
    return UITableViewCell()
  }

  // MARK: - Table View Delegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.row == 1 else { return }
    switch indexPath.section {
    case 0: choosingCountry.toggle()
    case 1: choosingState.toggle()
    default: return
    }
    tableView.reloadData()
  }
}

// MARK: - Picker View Data Source & Delegate

extension LocationVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0: return countries.count
        case 1: return choosingUSStates ? states.count : provinces.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0: return countries[row]
        case 1: return choosingUSStates ? states[row] : provinces[row]
        default: return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            selectedCountry = countries[row]
            if canChooseState {
                let selectedUS = selectedCountry == "United States (US)"
                // If changing countries directly from US/Canada to the other, reset the state/province
                if choosingUSStates != selectedUS {
                    selectedState = "-"
                }
                choosingUSStates = selectedUS
                statePickerView.reloadAllComponents()
            } else {
                // Disable choosing a state/province if US or Canada was not selected
                specificStateSwitch.isOn = false
                usingSpecificState = false
                choosingState = false
            }
        case 1: selectedState = choosingUSStates ? states[row] : provinces[row]
        default: return
        }
        tableView.reloadData()
        requestTournamentsReload()
    }
}

// MARK: - States & Provinces

extension LocationVC {
    private static func getStates() -> [String] {
        return ["-",
                "Alabama (AL)",
                "Alaska (AK)",
                "Arizona (AZ)",
                "Arkansas (AR)",
                "California (CA)",
                "Colorado (CO)",
                "Connecticut (CT)",
                "Delaware (DE)",
                "Florida (FL)",
                "Georgia (GA)",
                "Hawaii (HI)",
                "Idaho (ID)",
                "Illinois (IL)",
                "Indiana (IN)",
                "Iowa (IA)",
                "Kansas (KS)",
                "Kentucky (KY)",
                "Louisiana (LA)",
                "Maine (ME)",
                "Maryland (MD)",
                "Massachusetts (MA)",
                "Michigan (MI)",
                "Minnesota (MN)",
                "Mississippi (MS)",
                "Missouri (MO)",
                "Montana (MT)",
                "Nebraska (NE)",
                "Nevada (NV)",
                "New Hampshire (NH)",
                "New Jersey (NJ)",
                "New Mexico (NM)",
                "New York (NY)",
                "North Carolina (NC)",
                "North Dakota (ND)",
                "Ohio (OH)",
                "Oklahoma (OK)",
                "Oregon (OR)",
                "Pennsylvania (PA)",
                "Rhode Island (RI)",
                "South Carolina (SC)",
                "South Dakota (SD)",
                "Tennessee (TN)",
                "Texas (TX)",
                "Utah (UT)",
                "Vermont (VT)",
                "Virginia (VA)",
                "Washington (WA)",
                "West Virginia (WV)",
                "Wisconsin (WI)",
                "Wyoming (WY)"]
    }
    
    private static func getProvinces() -> [String] {
        return ["-",
                "Alberta (AB)",
                "British Columbia (BC)",
                "Manitoba (MB)",
                "New Brunswick (NB)",
                "Newfoundland (NL)",
                "Northwest Territories (NT)",
                "Nova Scotia (NS)",
                "Nunavut (NU)",
                "Ontario (ON)",
                "Prince Edward Island (PE)",
                "Quebec (QC)",
                "Saskatchewan (SK)",
                "Yukon (YT)"]
    }
}
