//
//  ProfileCell.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-07-25.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class ProfileCell: UITableViewCell {
    
    // MARK: - Initialization
    
    init() {
        super.init(style: .subtitle, reuseIdentifier: nil)
        selectionStyle = .none
        contentView.clipsToBounds = true
        setupImageView()
        setupLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupImageView() {
        imageView?.layer.cornerRadius = k.Sizes.cornerRadius
        imageView?.layer.masksToBounds = true
        imageView?.clipsToBounds = true
        imageView?.contentMode = .scaleAspectFill
        imageView?.image = UIImage(named: "icon-profile")
        imageView?.setSquareAspectRatio(sideLength: k.Sizes.tournamentListCellHeight)
        imageView?.setEdgeConstraints(top: contentView.topAnchor,
                                      leading: contentView.leadingAnchor,
                                      trailing: textLabel?.leadingAnchor,
                                      padding: UIEdgeInsets(top: 11, left: 11, bottom: 0, right: 11))
        
        if let imageView = imageView {
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor, constant: 11).isActive = true
        }
    }
    
    private func setupLabels() {
        textLabel?.numberOfLines = 0
        detailTextLabel?.numberOfLines = 0
        
        textLabel?.setEdgeConstraints(top: contentView.topAnchor,
                                      bottom: detailTextLabel?.topAnchor,
                                      leading: imageView?.trailingAnchor,
                                      trailing: contentView.trailingAnchor,
                                      padding: UIEdgeInsets(top: 11, left: 11, bottom: 0, right: 11))
        detailTextLabel?.setEdgeConstraints(top: textLabel?.bottomAnchor,
                                            leading: textLabel?.leadingAnchor,
                                            trailing: textLabel?.trailingAnchor)
        if let detailTextLabel = detailTextLabel {
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: detailTextLabel.bottomAnchor, constant: 11).isActive = true
        }
    }
    
    // MARK: - Public Methods
    
    func setLabelText(text: NSAttributedString?, detailText: String?) {
        textLabel?.attributedText = text
        detailTextLabel?.text = detailText
    }
    
    func setImage(_ URL: String?) {
        let newSize = CGSize(width: k.Sizes.tournamentListCellHeight, height: .zero)
        ImageService.getImage(imageUrl: URL, newSize: newSize) { image in
            guard let image = image else { return }
            DispatchQueue.main.async { [weak self] in
                self?.imageView?.image = image
            }
        }
    }
}
