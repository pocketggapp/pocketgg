//
//  RoundRobinSetCell.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-12-15.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

enum RoundRobinSetCellType {
  case topCorner
  case blank
  case setScore
  case entrantName
  case overallEntrantScore
}

final class RoundRobinSetCell: UICollectionViewCell {
    
  private var type: RoundRobinSetCellType?
  private var set: PhaseGroupSet?
  private let label = UILabel()
  
  // MARK: Initialization
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupLabel()
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentSetCard)))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLabel() {
    label.textAlignment = .center
    contentView.addSubview(label)
    label.setEdgeConstraints(
      top: contentView.topAnchor,
      bottom: contentView.bottomAnchor,
      leading: contentView.leadingAnchor,
      trailing: contentView.trailingAnchor
    )
  }
  
  // MARK: Actions
  
  @objc private func presentSetCard() {
    guard let type = type, type == .setScore else { return }
    NotificationCenter.default.post(name: Notification.Name(k.Notification.didTapSet), object: set)
  }
  
  // MARK: Public Methods
  
  func setupCell(type: RoundRobinSetCellType, set: PhaseGroupSet? = nil) {
    self.type = type
    self.set = set
    
    switch type {
    case .topCorner, .entrantName:
      contentView.backgroundColor = .clear
    case .blank:
      contentView.backgroundColor = .secondarySystemBackground
    case .setScore:
      contentView.backgroundColor = .systemBackground
    case .overallEntrantScore:
      contentView.backgroundColor = .clear
      label.numberOfLines = 2
    }
  }
  
  func setupSetScoreCell(_ entrant: Entrant?) {
    let color: UIColor
    let outcome = SetUtilities.getSetOutcome(set)
    
    switch outcome {
    case .entrant0Won:
      guard let id = entrant?.id, let id0 = set?.entrants?[safe: 0]?.entrant?.id else {
        color = .systemGray
        return
      }
      color = id == id0 ? .systemGreen : .systemRed
    case .entrant1Won:
      guard let id = entrant?.id, let id1 = set?.entrants?[safe: 1]?.entrant?.id else {
        color = .systemGray
        return
      }
      color = id == id1 ? .systemGreen : .systemRed
    case .noWinner:
      color = .systemGray
    }
    
    let score0 = set?.entrants?[safe: 0]?.score ?? "_"
    let score1 = set?.entrants?[safe: 1]?.score ?? "_"
    
    let text: String
    if (outcome == .entrant0Won && color == UIColor.systemGreen) || (outcome == .entrant1Won && color == UIColor.systemRed) {
      text = score0 + " - " + score1
    } else if (outcome == .entrant0Won && color == UIColor.systemRed) || (outcome == .entrant1Won && color == UIColor.systemGreen) {
      text = score1 + " - " + score0
    } else {
      text = "-"
    }
    
    label.text = text
    label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
    label.textColor = color
    contentView.layer.borderWidth = 2
    contentView.layer.borderColor = color.cgColor
  }
  
  func setupEntrantCell(_ entrant: Entrant?) {
    label.attributedText = SetUtilities.getAttributedEntrantText(entrant, bold: true, size: label.font.pointSize, teamNameLength: entrant?.teamName?.count)
  }
  
  func setupOverallEntrantScoreCell(_ text: String?) {
    guard let text = text else { return }
    
    let attributedText = NSMutableAttributedString(string: text)
    attributedText.addAttribute(.font,
                                value: UIFont.boldSystemFont(ofSize: label.font.pointSize),
                                range: NSRange(location: 0, length: text.count))
    
    if let range = text.range(of: "\n") {
      let gameScoreIndex = text[..<range.lowerBound].count
      let gameScoreLength = text[range.upperBound...].count + 1
      attributedText.addAttribute(.foregroundColor,
                                  value: UIColor.systemGray,
                                  range: NSRange(location: gameScoreIndex, length: gameScoreLength))
    }
    
    label.attributedText = attributedText
  }
}
