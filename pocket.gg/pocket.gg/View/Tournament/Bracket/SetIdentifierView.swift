//
//  SetIdentifierView.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-06-08.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class SetIdentifierView: UIView {
    
  private let setIdentifierLabel: UILabel
  
  // MARK: Initialization
  
  init(setIdentifier: String, xPos: CGFloat, yPos: CGFloat) {
    setIdentifierLabel = UILabel()
    setIdentifierLabel.text = setIdentifier
    setIdentifierLabel.textColor = .white
    setIdentifierLabel.textAlignment = .center
    
    super.init(frame: CGRect(x: xPos, y: yPos, width: k.Sizes.setHeight / 2, height: k.Sizes.setHeight / 2))
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setup
  
  private func setup() {
    backgroundColor = .systemGray3
    layer.cornerRadius = k.Sizes.cornerRadius
    
    addSubview(setIdentifierLabel)
    setIdentifierLabel.setAxisConstraints(xAnchor: centerXAnchor, yAnchor: centerYAnchor)
  }
}
