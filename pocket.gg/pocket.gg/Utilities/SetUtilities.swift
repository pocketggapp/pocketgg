//
//  SetUtilities.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-06-25.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class SetUtilities {
  
  static func getSetOutcome(_ set: PhaseGroupSet?) -> SetOutcome {
    guard let set = set else { return .noWinner }
    
    if let score0 = set.entrants?[safe: 0]?.score, let score1 = set.entrants?[safe: 1]?.score {
      if let score0Num = Int(score0), let score1Num = Int(score1) {
        if score0Num > score1Num {
          return .entrant0Won
        } else if score1Num > score0Num {
          return .entrant1Won
        } else {
          return .noWinner
        }
      } else if score0 == "W" || score0 == "✓" {
          return .entrant0Won
    } else if score1 == "W" || score1 == "✓" {
        return .entrant1Won
      } else {
        return .noWinner
      }
    } else {
      return .noWinner
    }
  }
  
  static func getAttributedEntrantText(_ entrant: Entrant?, bold: Bool, size: CGFloat, teamNameLength: Int?) -> NSAttributedString {
    guard let entrant = entrant else { return NSMutableAttributedString() }
    
    let text: String
    if let teamName = entrant.teamName {
      text = teamName + " " + (entrant.name ?? "")
    } else if let entrantName = entrant.name {
      text = entrantName
    } else {
      text = "_"
    }
    
    let attributedText = NSMutableAttributedString(string: text)
    
    if bold {
      attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: size), range: NSRange(location: 0, length: text.count))
    }
    
    if let teamNameLength = teamNameLength {
      attributedText.addAttribute(.foregroundColor, value: UIColor.systemGray, range: NSRange(location: 0, length: teamNameLength))
    }
    
    return attributedText
  }
  
  static func getAttributedScoreText(entrant0Score: String?, entrant1Score: String?, outcome: SetOutcome, size: CGFloat) -> NSAttributedString {
    let score0 = entrant0Score ?? "_"
    let score1 = entrant1Score ?? "_"
    let attributedText = NSMutableAttributedString(string: score0 + " - " + score1)
    
    if outcome == .entrant0Won {
      attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: size), range: NSRange(location: 0, length: score0.count))
      attributedText.addAttribute(.foregroundColor, value: UIColor.systemGreen, range: NSRange(location: 0, length: score0.count))
    } else if outcome == .entrant1Won {
      let location = score0.count + 3
      attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: size), range: NSRange(location: location, length: score1.count))
      attributedText.addAttribute(.foregroundColor, value: UIColor.systemGreen, range: NSRange(location: location, length: score1.count))
    }
    
    return attributedText
  }
}

// MARK: - UILabel Attribute Helper

extension UILabel {
  func addAttributes(text: String?, bold: Bool, color: UIColor? = nil) {
    self.text = text
    if bold {
      font = UIFont.boldSystemFont(ofSize: font.pointSize)
    }
    if let color = color {
      textColor = color
    }
  }
}
