//
//  Value1Cell.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-03-15.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

final class Value1Cell: UITableViewCell {

  // MARK: - Initialization
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    textLabel?.numberOfLines = 0
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public Methods
  
  func updateLabels(text: String? = nil, attributedText: NSAttributedString? = nil, detailText: String?) {
    if let attributedText = attributedText {
      textLabel?.attributedText = attributedText
    } else {
      textLabel?.text = text
    }
    detailTextLabel?.text = detailText
  }
}
