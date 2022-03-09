//
//  TournamentGeneralInfoCell.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-02-14.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

final class TournamentGeneralInfoCell: UITableViewCell {
    
    let tournament: Tournament
    let cacheForLogo: Cache
    
    let logoImageView = UIImageView(image: UIImage(named: "game-controller-square"))
    let dateIconView = UIImageView(image: UIImage(systemName: "calendar"))
    let locationIconView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let locationLabel = UILabel()
    
    let dateStackView = UIStackView()
    let locationStackView = UIStackView()
    let labelStackView = UIStackView()
    let totalStackView = UIStackView()
    
    // MARK: - Initialization
    
    init(_ tournament: Tournament, cacheForLogo: Cache) {
        self.tournament = tournament
        self.cacheForLogo = cacheForLogo
        
        dateIconView.tintColor = .label
        locationIconView.tintColor = .label
        
        super.init(style: .default, reuseIdentifier: nil)
        
        selectionStyle = .none
        setupViews()
        setupStackViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupViews() {
        logoImageView.layer.cornerRadius = k.Sizes.cornerRadius
        logoImageView.layer.masksToBounds = true
        ImageService.getImage(imageUrl: tournament.logoUrl, cache: cacheForLogo) { [weak self] (logo) in
            guard let logo = logo else { return }
            DispatchQueue.main.async {
                self?.logoImageView.image = logo
            }
        }
        
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.boldSystemFont(ofSize: k.Sizes.largeFont)
        nameLabel.text = tournament.name
        
        dateLabel.numberOfLines = 0
        dateLabel.text = tournament.date
        
        locationLabel.numberOfLines = 0
        guard !(tournament.isOnline ?? true) else {
            locationLabel.text = "Online"
            return
        }
        guard let address = tournament.location?.address else {
            locationLabel.text = "Location not available"
            return
        }
        locationLabel.text = address
    }
    
    private func setupStackViews() {
        dateStackView.setup(subviews: [dateIconView, dateLabel], axis: .horizontal, alignment: .center, spacing: 5)
        locationStackView.setup(subviews: [locationIconView, locationLabel], axis: .horizontal, alignment: .center, spacing: 5)
        labelStackView.setup(subviews: [nameLabel, dateStackView, locationStackView], axis: .vertical, spacing: 5)
        totalStackView.setup(subviews: [logoImageView, labelStackView], axis: .horizontal, alignment: .top, spacing: 10)
        contentView.addSubview(totalStackView)
    }
    
    private func setConstraints() {
        dateIconView.setSquareAspectRatio(sideLength: dateLabel.font.pointSize)
        locationIconView.setSquareAspectRatio(sideLength: locationLabel.font.pointSize)
        
        logoImageView.setSquareAspectRatio(sideLength: k.Sizes.logoSideLength)
        totalStackView.setEdgeConstraints(top: contentView.topAnchor,
                                          bottom: contentView.bottomAnchor,
                                          leading: contentView.leadingAnchor,
                                          trailing: contentView.trailingAnchor,
                                          padding: UIEdgeInsets.init(top: k.Sizes.margin, left: k.Sizes.margin,
                                                                     bottom: k.Sizes.margin, right: k.Sizes.margin))
    }
}
