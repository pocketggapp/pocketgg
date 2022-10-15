//
//  InvalidBracketView.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-12-06.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

final class InvalidBracketView: UIView {
    
  private let cause: InvalidBracketViewCause
  private var unsupportedBracketType: String?
  
  var imageName: String {
    switch cause {
    case .bracketLayoutError, .errorLoadingBracket: return "tournament-bracket-error"
    case .bracketNotStarted: return "tournament-bracket-not-started"
    case .noEntrants: return "tournament-bracket-missing-data"
    case .noSets: return "tournament-bracket-missing-data"
    case .unsupportedBracketType: return "tournament-bracket-unsupported"
    }
  }
  
  var titleText: String {
    switch cause {
    case .bracketLayoutError: return "Error generating Bracket"
    case .bracketNotStarted: return "Bracket not started"
    case .noEntrants: return "No Entrants"
    case .noSets: return "No Sets"
    case .unsupportedBracketType: return "Unsupported Bracket type"
    case .errorLoadingBracket: return "Error loading Bracket"
    }
  }
  
  var messageText: String {
    switch cause {
    case .bracketLayoutError: return "Unable to generate a bracket view for this bracket"
    case .bracketNotStarted: return "This bracket has not started yet. Check back again when the bracket starts"
    case .noEntrants: return "This event currently has no entrants."
    case .noSets: return "This bracket currently has no sets to be displayed."
    case .unsupportedBracketType:
      let bracketType = unsupportedBracketType != nil ? " (\(unsupportedBracketType ?? ""))" : ""
      return "This type of bracket is currently not supported." + bracketType
    case .errorLoadingBracket: return "There was an error loading this bracket, try checking your internet connection."
    }
  }
  
  // MARK: Initialization
  
  init(cause: InvalidBracketViewCause, bracketType: String? = nil) {
    self.cause = cause
    self.unsupportedBracketType = bracketType
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setup
  
  private func setup() {
    let imageView = UIImageView(image: UIImage(named: imageName))
    imageView.contentMode = .scaleAspectFit
    
    let titleLabel = UILabel()
    titleLabel.text = titleText
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
    titleLabel.numberOfLines = 0
    
    let messageLabel = UILabel()
    messageLabel.text = messageText
    messageLabel.textAlignment = .center
    messageLabel.numberOfLines = 0
    
    addSubview(imageView)
    addSubview(titleLabel)
    addSubview(messageLabel)
    
    messageLabel.setAxisConstraints(yAnchor: centerYAnchor)
    messageLabel.setEdgeConstraints(
      top: titleLabel.bottomAnchor,
      leading: leadingAnchor,
      trailing: trailingAnchor,
      padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    )
    
    titleLabel.setEdgeConstraints(
      top: imageView.bottomAnchor,
      bottom: messageLabel.topAnchor,
      leading: messageLabel.leadingAnchor,
      trailing: messageLabel.trailingAnchor,
      padding: UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    )
    
    imageView.setAxisConstraints(xAnchor: centerXAnchor)
    imageView.setEdgeConstraints(
      bottom: titleLabel.topAnchor,
      padding: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    )
    imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    imageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 16).isActive = true
  }
}
