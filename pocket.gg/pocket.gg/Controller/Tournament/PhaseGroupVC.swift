//
//  PhaseGroupVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-08-26.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

final class PhaseGroupVC: UIViewController {

  private var phaseGroup: PhaseGroup?
  private var phaseID: Int?
  private var doneRequest = false
  private var requestSuccessful = true

  private var lastRefreshTime: Date?

  private let phaseGroupViewControl: UISegmentedControl
  private let tableView: UITableView
  private let bracketScrollView: UIScrollView
  private var bracketView: BracketView?
  private var invalidBracketView: InvalidBracketView?
  private let bracketViewSpinner: UIActivityIndicatorView
  private let refreshPhaseGroupView: RefreshPhaseGroupView

  private var IDs: TournamentIDs

  // MARK: Initialization

  init(_ phaseGroup: PhaseGroup?, _ phaseID: Int? = nil, title: String?, IDs: TournamentIDs) {
    self.phaseGroup = phaseGroup
    self.phaseID = phaseID
    self.IDs = IDs
    self.IDs.phaseGroupID = phaseGroup?.id
    self.IDs.singularPhaseGroupID = phaseID

    phaseGroupViewControl = UISegmentedControl(items: ["Standings", "Matches", "Bracket"])
    phaseGroupViewControl.selectedSegmentIndex = 0

    tableView = UITableView(frame: .zero, style: .insetGrouped)

    bracketScrollView = UIScrollView(frame: .zero)
    bracketViewSpinner = UIActivityIndicatorView(style: .medium)
    refreshPhaseGroupView = RefreshPhaseGroupView()

    super.init(nibName: nil, bundle: nil)
    self.title = title

    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    tableView.refreshControl = refreshControl

    bracketScrollView.delegate = self

    refreshPhaseGroupView.refreshButton.addTarget(self, action: #selector(refreshData), for: .touchUpInside)

    NotificationCenter.default.addObserver(self, selector: #selector(presentSetVC(_:)),
                                           name: Notification.Name(k.Notification.didTapSet), object: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupViews()

    // phaseGroup should be nil only when the phase only has 1 phase group
    // In this case, the phase ID that was passed in will be used to fetch the phase group
    if phaseGroup == nil {
      getPhaseGroup { [weak self] in
        self?.loadPhaseGroupDetails()
      }
    } else {
      loadPhaseGroupDetails()
    }
  }

  // MARK: Setup

  private func setupViews() {
    view.addSubview(phaseGroupViewControl)
    view.addSubview(tableView)
    view.addSubview(bracketScrollView)
    view.addSubview(refreshPhaseGroupView)
    phaseGroupViewControl.setEdgeConstraints(
      top: view.layoutMarginsGuide.topAnchor,
      bottom: tableView.topAnchor,
      leading: view.leadingAnchor,
      trailing: view.trailingAnchor
    )
    tableView.setEdgeConstraints(
      top: phaseGroupViewControl.bottomAnchor,
      bottom: view.bottomAnchor,
      leading: view.leadingAnchor,
      trailing: view.trailingAnchor
    )
    bracketScrollView.setEdgeConstraints(
      top: phaseGroupViewControl.bottomAnchor,
      bottom: refreshPhaseGroupView.topAnchor,
      leading: view.leadingAnchor,
      trailing: view.trailingAnchor
    )
    refreshPhaseGroupView.setEdgeConstraints(
      top: bracketScrollView.bottomAnchor,
      bottom: view.safeAreaLayoutGuide.bottomAnchor,
      leading: view.leadingAnchor,
      trailing: view.trailingAnchor
    )

    tableView.register(Value1Cell.self, forCellReuseIdentifier: k.Identifiers.value1Cell)
    tableView.register(SetCell.self, forCellReuseIdentifier: k.Identifiers.tournamentSetCell)
    tableView.dataSource = self
    tableView.delegate = self

    bracketScrollView.isHidden = true
    refreshPhaseGroupView.isHidden = true

    bracketViewSpinner.startAnimating()
    bracketScrollView.addSubview(bracketViewSpinner)
    bracketViewSpinner.setAxisConstraints(xAnchor: bracketScrollView.centerXAnchor, yAnchor: bracketScrollView.centerYAnchor)

    phaseGroupViewControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
  }

  private func getPhaseGroup(_ complete: @escaping () -> Void) {
    guard let id = phaseID else { return }

    TournamentDetailsService.getPhaseGroups(id, numPhaseGroups: 1) { [weak self] (result) in
      guard let result = result, !result.isEmpty else {
        complete()
        return
      }
      self?.phaseGroup = result[safe: 0]
      complete()
    }
  }

  private func loadPhaseGroupDetails() {
    guard let id = phaseGroup?.id else {
      doneRequest = true
      requestSuccessful = false
      tableView.refreshControl?.endRefreshing()
      refreshPhaseGroupView.updateView(isLoading: false)
      tableView.reloadData()
      showInvalidBracketView(cause: .errorLoadingBracket)
      return
    }

    TournamentDetailsService.getPhaseGroup(id) { [weak self] (result) in
      guard let result = result else {
        self?.doneRequest = true
        self?.requestSuccessful = false
        self?.tableView.refreshControl?.endRefreshing()
        self?.refreshPhaseGroupView.updateView(isLoading: false)
        self?.tableView.reloadData()
        self?.showInvalidBracketView(cause: .errorLoadingBracket)
        return
      }

      self?.phaseGroup?.bracketType = result["bracketType"] as? String
      self?.phaseGroup?.progressionsOut = result["progressionsOut"] as? [Int]
      self?.phaseGroup?.standings = result["standings"] as? [Standing]
      self?.phaseGroup?.matches = result["sets"] as? [PhaseGroupSet]

      guard let standings = self?.phaseGroup?.standings, let matches = self?.phaseGroup?.matches else {
        self?.doneRequest = true
        self?.requestSuccessful = false
        self?.tableView.refreshControl?.endRefreshing()
        self?.refreshPhaseGroupView.updateView(isLoading: false)
        self?.tableView.reloadData()
        self?.showInvalidBracketView(cause: .errorLoadingBracket)
        return
      }

      // If 90 sets were returned, there may be more sets in total, so load the next page of sets
      if standings.count == 65 || matches.count == 90 {
        let nextStandingsPage: Int? = standings.count == 65 ? 2 : nil
        let nextSetsPage: Int? = matches.count == 90 ? 2 : nil
        self?.loadRemainingPhaseGroupData(id: id, standingsPage: nextStandingsPage, setsPage: nextSetsPage)
      } else {
        self?.doneRequest = true
        self?.requestSuccessful = true
        self?.tableView.refreshControl?.endRefreshing()
        self?.refreshPhaseGroupView.updateView(isLoading: false)
        self?.tableView.reloadData()
        self?.setupBracketView()
      }
    }
  }

  private func loadRemainingPhaseGroupData(id: Int, standingsPage: Int?, setsPage: Int?) {
    let dispatchGroup = DispatchGroup()

    // If more data needs to be loaded, these will hold the next page number to load from. Else, they will be nil
    var numStandingsReturned: Int?
    var numSetsReturned: Int?

    // Enter block(s) to the dispatch group if more standings and/or sets need to be loaded
    if standingsPage != nil { dispatchGroup.enter() }
    if setsPage != nil { dispatchGroup.enter() }

    // If more standings need to be loaded, load them and leave the dispatch group once finished
    if let page = standingsPage {
      // Upper limit to prevent potential infinite recursive calls
      if page < 6 {
        TournamentDetailsService.getPhaseGroupStandings(id, page: page) { [weak self] (standings) in
          guard let standings = standings, !standings.isEmpty else {
            dispatchGroup.leave()
            return
          }
          self?.phaseGroup?.standings?.append(contentsOf: standings)

          numStandingsReturned = standings.count
          dispatchGroup.leave()
        }
      } else {
        dispatchGroup.leave()
      }
    }

    // If more sets need to be loaded, load them and leave the dispatch group once finished
    if let page = setsPage {
      // Upper limit to prevent potential infinite recursive calls
      if page < 6 {
        TournamentDetailsService.getPhaseGroupSets(id, page: page) { [weak self] (sets) in
          guard let sets = sets, !sets.isEmpty else {
            dispatchGroup.leave()
            return
          }
          self?.phaseGroup?.matches?.append(contentsOf: sets)

          numSetsReturned = sets.count
          dispatchGroup.leave()
        }
      } else {
        dispatchGroup.leave()
      }
    }

    // Callback for when the request(s) finishes
    dispatchGroup.notify(queue: .main) { [weak self] in
      var nextStandingsPage: Int?
      var nextSetsPage: Int?
      if let numStandingsReturned = numStandingsReturned, numStandingsReturned == 65 {
        if let standingsPage = standingsPage {
          nextStandingsPage = standingsPage + 1
        }
      }
      if let numSetsReturned = numSetsReturned, numSetsReturned == 90 {
        if let setsPage = setsPage {
          nextSetsPage = setsPage + 1
        }
      }

      // If more data needs to be loaded, recursively call this function until all of the data is loaded
      if nextStandingsPage != nil || nextSetsPage != nil {
        self?.loadRemainingPhaseGroupData(id: id, standingsPage: nextStandingsPage, setsPage: nextSetsPage)
      } else {
        self?.doneRequest = true
        self?.requestSuccessful = true
        self?.tableView.refreshControl?.endRefreshing()
        self?.refreshPhaseGroupView.updateView(isLoading: false)
        self?.tableView.reloadData()
        self?.setupBracketView()
      }
    }
  }

  private func setupBracketView() {
    // TODO: Potentially improve performance by moving some of this work to a background thread
    switch phaseGroup?.bracketType ?? "" {
    case "SINGLE_ELIMINATION", "DOUBLE_ELIMINATION":
      bracketView = EliminationBracketView(sets: phaseGroup?.matches)
    case "ROUND_ROBIN":
      let entrants = phaseGroup?.standings?.compactMap { $0.entrant }
      bracketView = RoundRobinBracketView(sets: phaseGroup?.matches, entrants: entrants)
    default:
      break
    }

    if let bracketView = bracketView {
      if bracketView.isValid {
        bracketViewSpinner.isHidden = true
        bracketScrollView.contentSize = bracketView.bounds.size
        bracketScrollView.maximumZoomScale = 2
        bracketScrollView.minimumZoomScale = 0.5
        bracketScrollView.addSubview(bracketView)
      } else {
        showInvalidBracketView(cause: bracketView.invalidationCause ?? .bracketLayoutError)
      }
    } else {
      showInvalidBracketView(cause: .unsupportedBracketType, bracketType: phaseGroup?.bracketType)
    }
  }

  // MARK: Actions

  @objc private func refreshData() {
    tableView.refreshControl?.beginRefreshing()
    refreshPhaseGroupView.updateView(isLoading: true)
    if let lastRefreshTime = lastRefreshTime {
      // Don't allow refreshing more than once every 5 seconds
      guard Date().timeIntervalSince(lastRefreshTime) > 5 else {
        tableView.refreshControl?.endRefreshing()
        refreshPhaseGroupView.updateView(isLoading: false)
        return
      }
    }

    bracketView?.removeFromSuperview()
    bracketView = nil
    invalidBracketView?.removeFromSuperview()
    invalidBracketView = nil
    bracketViewSpinner.isHidden = false
    bracketScrollView.contentSize = .zero

    lastRefreshTime = Date()
    loadPhaseGroupDetails()
  }

  @objc private func presentSetVC(_ notification: Notification) {
    if let set = notification.object as? PhaseGroupSet {
      present(UINavigationController(rootViewController: SetVC(set)), animated: true, completion: nil)
    }
  }

  @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    tableView.isHidden = sender.selectedSegmentIndex == 2
    bracketScrollView.isHidden = sender.selectedSegmentIndex != 2
    refreshPhaseGroupView.isHidden = sender.selectedSegmentIndex != 2

    if sender.selectedSegmentIndex != 2 {
      tableView.reloadData()
    }
  }

  private func showInvalidBracketView(cause: InvalidBracketViewCause, bracketType: String? = nil) {
    if cause == .bracketLayoutError {
      FirebaseService.reportPhaseGroup(IDs)
    }
    bracketViewSpinner.isHidden = true
    invalidBracketView = InvalidBracketView(cause: cause, bracketType: bracketType)
    guard let invalidBracketView = invalidBracketView else { return }
    bracketScrollView.addSubview(invalidBracketView)
    bracketScrollView.maximumZoomScale = 1
    bracketScrollView.minimumZoomScale = 1
    invalidBracketView.setEdgeConstraints(
      top: bracketScrollView.safeAreaLayoutGuide.topAnchor,
      bottom: bracketScrollView.safeAreaLayoutGuide.bottomAnchor,
      leading: bracketScrollView.safeAreaLayoutGuide.leadingAnchor,
      trailing: bracketScrollView.safeAreaLayoutGuide.trailingAnchor
    )
  }
}

// MARK: - Table View Data Source & Delegate

extension PhaseGroupVC: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard doneRequest, requestSuccessful else { return 1 }
    switch phaseGroupViewControl.selectedSegmentIndex {
    case 0:
      guard let standings = phaseGroup?.standings, !standings.isEmpty else { return 1 }
      return standings.count
    case 1:
      guard let sets = phaseGroup?.matches, !sets.isEmpty else { return 1 }
      return sets.count
    default: return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard doneRequest else { return LoadingCell() }
    guard requestSuccessful else {
      let text = phaseGroupViewControl.selectedSegmentIndex == 0 ? k.Message.errorLoadingPhaseGroupStandings : k.Message.errorLoadingSets
      return UITableViewCell().setupDisabled(text)
    }

    var standings = [Standing]()
    var sets = [PhaseGroupSet]()

    switch phaseGroupViewControl.selectedSegmentIndex {
    case 0:
      guard let phaseGroupStandings = phaseGroup?.standings else { return UITableViewCell().setupDisabled(k.Message.errorLoadingPhaseGroupStandings) }
      guard !phaseGroupStandings.isEmpty else { return UITableViewCell().setupDisabled(k.Message.noStandings) }
      standings = phaseGroupStandings
    case 1:
      guard let phaseGroupSets = phaseGroup?.matches else { return UITableViewCell().setupDisabled(k.Message.errorLoadingSets) }
      guard !phaseGroupSets.isEmpty else { return UITableViewCell().setupDisabled(k.Message.noSets) }
      sets = phaseGroupSets
    default: return UITableViewCell()
    }

    switch phaseGroupViewControl.selectedSegmentIndex {
    case 0:
      if let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.value1Cell, for: indexPath) as? Value1Cell {
        guard let standing = standings[safe: indexPath.row] else { break }

        cell.selectionStyle = .none

        var placementText = ""
        var progressedText: String?

        var teamNameStart: Int?
        var teamNameLength: Int?
        if let placement = standing.placement {
          placementText = "\(placement): "
          teamNameStart = placementText.count
          if let progressionsOut = phaseGroup?.progressionsOut, progressionsOut.contains(placement) {
            // TODO: If possible with the API, also display where the player has progressed to
            progressedText = "Progressed"
          }
        }
        if let entrantName = standing.entrant?.name {
          if let teamName = standing.entrant?.teamName {
            placementText += teamName + " "
            teamNameLength = teamName.count
          }
          placementText += entrantName
        }

        let attributedText = NSMutableAttributedString(string: placementText)
        if let location = teamNameStart, let length = teamNameLength {
          attributedText.addAttribute(.foregroundColor, value: UIColor.systemGray, range: NSRange(location: location, length: length))
        }

        cell.updateLabels(attributedText: attributedText, detailText: progressedText)
        return cell
      }

    case 1:
      if let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.tournamentSetCell, for: indexPath) as? SetCell {
        guard let set = sets[safe: indexPath.row] else { break }
        cell.addSetInfo(set)
        return cell
      }

    default: break
    }
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard phaseGroupViewControl.selectedSegmentIndex == 1 else { return }
    guard let set = phaseGroup?.matches?[safe: indexPath.row] else { return }
    present(UINavigationController(rootViewController: SetVC(set)), animated: true, completion: nil)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: - Scroll View Delegate

extension PhaseGroupVC: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return bracketView
  }
}
