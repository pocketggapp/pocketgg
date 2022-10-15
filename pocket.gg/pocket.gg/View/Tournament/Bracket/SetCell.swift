//
//  SetCell.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-06-23.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class SetCell: UITableViewCell {
    
  private let setDescriptionLabel = UILabel()
  private let entrantLabel0 = UILabel()
  private let entrantLabel1 = UILabel()
  private let scoreLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    return label
  }()
  private let setStateLabel = UILabel()
  
  // MARK: Initialization
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    setupLabels()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLabels() {
    let vsLabel = UILabel()
    vsLabel.text = "vs."
    vsLabel.textAlignment = .center
    
    entrantLabel0.numberOfLines = 0
    entrantLabel1.numberOfLines = 0
    
    let labelsContainer = UIView()
    labelsContainer.addSubview(vsLabel)
    labelsContainer.addSubview(entrantLabel0)
    labelsContainer.addSubview(entrantLabel1)
    
    contentView.addSubview(setDescriptionLabel)
    contentView.addSubview(labelsContainer)
    contentView.addSubview(scoreLabel)
    contentView.addSubview(setStateLabel)
    setDescriptionLabel.setEdgeConstraints(
      top: contentView.topAnchor,
      bottom: labelsContainer.topAnchor,
      leading: contentView.leadingAnchor,
      trailing: contentView.trailingAnchor,
      padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    vsLabel.setAxisConstraints(xAnchor: labelsContainer.centerXAnchor)
    vsLabel.setEdgeConstraints(
      top: labelsContainer.topAnchor,
      bottom: labelsContainer.bottomAnchor,
      leading: entrantLabel0.trailingAnchor,
      trailing: entrantLabel1.leadingAnchor,
      padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    )
    entrantLabel0.setEdgeConstraints(
      top: labelsContainer.topAnchor,
      bottom: labelsContainer.bottomAnchor,
      leading: labelsContainer.leadingAnchor,
      trailing: vsLabel.leadingAnchor,
      padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
    )
    entrantLabel1.setEdgeConstraints(
      top: labelsContainer.topAnchor,
      bottom: labelsContainer.bottomAnchor,
      leading: vsLabel.trailingAnchor,
      trailing: labelsContainer.trailingAnchor,
      padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    )
    labelsContainer.setEdgeConstraints(
      top: setDescriptionLabel.bottomAnchor,
      bottom: scoreLabel.topAnchor,
      leading: contentView.leadingAnchor,
      trailing: contentView.trailingAnchor,
      padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    scoreLabel.setEdgeConstraints(
      top: labelsContainer.bottomAnchor,
      bottom: setStateLabel.topAnchor,
      leading: contentView.leadingAnchor,
      trailing: contentView.trailingAnchor,
      padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    setStateLabel.setEdgeConstraints(
      top: scoreLabel.bottomAnchor,
      bottom: contentView.bottomAnchor,
      leading: contentView.leadingAnchor,
      trailing: contentView.trailingAnchor,
      padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
  }
  
  func addSetInfo(_ set: PhaseGroupSet?) {
    guard let set = set else { return }
    let outcome = SetUtilities.getSetOutcome(set)
    
    var setDescriptionText = ""
    if let fullRoundText = set.fullRoundText {
      setDescriptionText += fullRoundText
    }
    if !set.identifier.isEmpty {
      setDescriptionText += " • Match " + set.identifier
    }
    setDescriptionLabel.text = setDescriptionText
    setDescriptionLabel.textAlignment = .center
    setDescriptionLabel.textColor = .systemGray
    
    setStateLabel.text = set.state?.capitalized
    setStateLabel.textAlignment = .right
    setStateLabel.textColor = .systemGray
    
    let entrant0 = set.entrants?[safe: 0]?.entrant
    let entrant1 = set.entrants?[safe: 1]?.entrant
    
    entrantLabel0.textAlignment = .right
    entrantLabel0.attributedText = SetUtilities.getAttributedEntrantText(
      entrant0,
      bold: outcome == .entrant0Won,
      size: entrantLabel0.font.pointSize,
      teamNameLength: entrant0?.teamName?.count
    )
    entrantLabel1.attributedText = SetUtilities.getAttributedEntrantText(
      entrant1,
      bold: outcome == .entrant1Won,
      size: entrantLabel1.font.pointSize,
      teamNameLength: entrant1?.teamName?.count
    )
    
    scoreLabel.attributedText = SetUtilities.getAttributedScoreText(
      entrant0Score: set.entrants?[safe: 0]?.score,
      entrant1Score: set.entrants?[safe: 1]?.score,
      outcome: outcome, size: scoreLabel.font.pointSize
    )
  }
}
