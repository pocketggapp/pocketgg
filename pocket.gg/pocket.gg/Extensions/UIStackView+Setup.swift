//
//  UIStackView+Setup.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-03-15.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

extension UIStackView {
  func setup(subviews: [UIView], axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0) {
    subviews.forEach { addArrangedSubview($0) }
    self.axis = axis
    self.alignment = alignment
    self.spacing = spacing
  }
}
