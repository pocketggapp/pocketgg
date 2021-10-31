//
//  LoadingView.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-09-02.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class LoadingView: UIView {
    
    let spinner = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupSpinner()
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = k.Sizes.cornerRadius
        widthAnchor.constraint(equalToConstant: 50).isActive = true
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupSpinner() {
        spinner.startAnimating()
        addSubview(spinner)
        spinner.setAxisConstraints(xAnchor: centerXAnchor, yAnchor: centerYAnchor)
    }
}
