//
//  SetView.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-11-07.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

enum SetOutcome {
  case entrant0Won
  case entrant1Won
  case noWinner
}

final class SetView: UIView {
    
  private let set: PhaseGroupSet
  private let outcome: SetOutcome
  
  private let size = UILabel().font.pointSize
  
  private let labelsContainer = UIView()
  
  // MARK: Initialization
  
  init(set: PhaseGroupSet, xPos: CGFloat, yPos: CGFloat) {
    self.set = set
    outcome = SetUtilities.getSetOutcome(set)
    super.init(frame: CGRect(x: xPos, y: yPos, width: k.Sizes.setWidth, height: k.Sizes.setHeight))
    
    setupAppearance()
    setupEntrantLabels()
    setupScoreLabels()
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentSetCard)))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setup
  
  private func setupAppearance() {
    backgroundColor = .secondarySystemBackground
    layer.cornerRadius = k.Sizes.cornerRadius
    layer.masksToBounds = true
  }
  
  private func setupEntrantLabels() {
    addSubview(labelsContainer)
    
    let entrantLabel0 = UILabel()
    if outcome == .entrant0Won {
      entrantLabel0.addAttributes(text: set.entrants?[safe: 0]?.entrant?.name, bold: true)
    } else {
      entrantLabel0.text = set.entrants?[safe: 0]?.entrant?.name
    }
    labelsContainer.addSubview(entrantLabel0)
    
    let entrantLabel1 = UILabel()
    if outcome == .entrant1Won {
      entrantLabel1.addAttributes(text: set.entrants?[safe: 1]?.entrant?.name, bold: true)
    } else {
      entrantLabel1.text = set.entrants?[safe: 1]?.entrant?.name
    }
    labelsContainer.addSubview(entrantLabel1)
    
    labelsContainer.setEdgeConstraints(
      top: topAnchor,
      bottom: bottomAnchor,
      leading: leadingAnchor,
      padding: UIEdgeInsets(top: 2, left: (k.Sizes.setHeight / 4) + 5, bottom: 2, right: 0)
    )
    
    // Team for Entrant 0
    if set.entrants?[safe: 0]?.entrant?.teamName != nil {
      let teamLabel0 = UILabel()
      teamLabel0.addAttributes(text: set.entrants?[safe: 0]?.entrant?.teamName, bold: outcome == .entrant0Won, color: .systemGray)
      labelsContainer.addSubview(teamLabel0)
      
      teamLabel0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      teamLabel0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
      
      let minWidth = min(teamLabel0.intrinsicContentSize.width, k.Sizes.setWidth / 7)
      teamLabel0.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth).isActive = true
      
      teamLabel0.setEdgeConstraints(
        top: labelsContainer.topAnchor,
        leading: labelsContainer.leadingAnchor,
        trailing: entrantLabel0.leadingAnchor,
        padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
      )
      entrantLabel0.setEdgeConstraints(
        top: labelsContainer.topAnchor,
        leading: teamLabel0.trailingAnchor,
        trailing: labelsContainer.trailingAnchor,
        padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 10)
      )
    } else {
      entrantLabel0.setEdgeConstraints(
        top: labelsContainer.topAnchor,
        leading: labelsContainer.leadingAnchor,
        trailing: labelsContainer.trailingAnchor,
        padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
      )
    }
    
    // Team for Entrant 1
    if set.entrants?[safe: 1]?.entrant?.teamName != nil {
      let teamLabel1 = UILabel()
      teamLabel1.addAttributes(text: set.entrants?[safe: 1]?.entrant?.teamName, bold: outcome == .entrant1Won, color: .systemGray)
      labelsContainer.addSubview(teamLabel1)
      
      teamLabel1.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      teamLabel1.setContentHuggingPriority(.defaultHigh, for: .horizontal)
      
      let minWidth = min(teamLabel1.intrinsicContentSize.width, k.Sizes.setWidth / 7)
      teamLabel1.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth).isActive = true
      
      teamLabel1.setEdgeConstraints(
        bottom: labelsContainer.bottomAnchor,
        leading: labelsContainer.leadingAnchor,
        trailing: entrantLabel1.leadingAnchor,
        padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
      )
      entrantLabel1.setEdgeConstraints(
        bottom: labelsContainer.bottomAnchor,
        leading: teamLabel1.trailingAnchor,
        trailing: labelsContainer.trailingAnchor,
        padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 10)
      )
    } else {
      entrantLabel1.setEdgeConstraints(
        bottom: labelsContainer.bottomAnchor,
        leading: labelsContainer.leadingAnchor,
        trailing: labelsContainer.trailingAnchor,
        padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
      )
    }
  }
  
  private func setupScoreLabels() {
    let scoreLabel0Container = UIView()
    addSubview(scoreLabel0Container)
    
    let scoreLabel1Container = UIView()
    addSubview(scoreLabel1Container)
    
    let scoreLabel0 = UILabel()
    scoreLabel0.textAlignment = .center
    scoreLabel0Container.addSubview(scoreLabel0)
    
    let scoreLabel1 = UILabel()
    scoreLabel1.textAlignment = .center
    scoreLabel1Container.addSubview(scoreLabel1)
    
    if outcome == .entrant0Won {
      scoreLabel0.addAttributes(text: set.entrants?[safe: 0]?.score, bold: true, color: .white)
      scoreLabel0Container.backgroundColor = .systemGreen
      scoreLabel1.addAttributes(text: set.entrants?[safe: 1]?.score, bold: false, color: .white)
      scoreLabel1Container.backgroundColor = .systemGray2
    } else if outcome == .entrant1Won {
      scoreLabel1.addAttributes(text: set.entrants?[safe: 1]?.score, bold: true, color: .white)
      scoreLabel1Container.backgroundColor = .systemGreen
      scoreLabel0.addAttributes(text: set.entrants?[safe: 0]?.score, bold: false, color: .white)
      scoreLabel0Container.backgroundColor = .systemGray2
    }
    
    scoreLabel0Container.setEdgeConstraints(
      top: topAnchor,
      bottom: centerYAnchor,
      leading: labelsContainer.trailingAnchor,
      trailing: trailingAnchor
    )
    scoreLabel1Container.setEdgeConstraints(
      top: centerYAnchor,
      bottom: bottomAnchor,
      leading: labelsContainer.trailingAnchor,
      trailing: trailingAnchor
    )
    scoreLabel0.setEdgeConstraints(
      top: scoreLabel0Container.topAnchor,
      bottom: scoreLabel0Container.bottomAnchor,
      leading: scoreLabel0Container.leadingAnchor,
      trailing: scoreLabel0Container.trailingAnchor,
      padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    )
    scoreLabel1.setEdgeConstraints(
      top: scoreLabel1Container.topAnchor,
      bottom: scoreLabel1Container.bottomAnchor,
      leading: scoreLabel1Container.leadingAnchor,
      trailing: scoreLabel1Container.trailingAnchor,
      padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    )
    let maxWidth = max(scoreLabel0.intrinsicContentSize.width, scoreLabel1.intrinsicContentSize.width)
    scoreLabel0.widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
    scoreLabel1.widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
  }
  
  // MARK: Actions
  
  @objc private func presentSetCard() {
    NotificationCenter.default.post(name: Notification.Name(k.Notification.didTapSet), object: set)
  }
}
