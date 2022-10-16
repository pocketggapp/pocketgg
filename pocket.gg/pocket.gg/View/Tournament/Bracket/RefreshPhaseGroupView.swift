//
//  RefreshPhaseGroupView.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-07-06.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class RefreshPhaseGroupView: UIView {
    
  let refreshButton: UIButton
  private let spinner: UIActivityIndicatorView
  
  // MARK: Initialization
  
  init() {
    refreshButton = UIButton(type: .system)
    spinner = UIActivityIndicatorView(style: .medium)
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setup
  
  private func setup() {
    refreshButton.setTitle("Refresh", for: .normal)
    refreshButton.setTitleColor(.systemRed, for: .normal)
    
    refreshButton.isHidden = true
    spinner.startAnimating()
    
    addSubview(refreshButton)
    addSubview(spinner)
    refreshButton.setEdgeConstraints(
      top: topAnchor,
      bottom: bottomAnchor,
      leading: leadingAnchor,
      trailing: trailingAnchor
    )
    refreshButton.heightAnchor.constraint(equalToConstant: k.Sizes.buttonHeight).isActive = true
    spinner.setAxisConstraints(xAnchor: centerXAnchor, yAnchor: centerYAnchor)
  }
  
  // MARK: Public Methods
  
  func updateView(isLoading: Bool) {
    refreshButton.isHidden = isLoading
    spinner.isHidden = !isLoading
  }
}
