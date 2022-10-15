//
//  ScrollableRowItemCell.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-05-01.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class ScrollableRowItemCell: UICollectionViewCell {
  
  private var imageView: UIImageView
  private var primaryLabel: UILabel
  private var secondaryLabel: UILabel
  
  // MARK: Initialization
  
  override init(frame: CGRect) {
    imageView = UIImageView(image: UIImage(named: "placeholder"))
    primaryLabel = UILabel(frame: .zero)
    secondaryLabel = UILabel(frame: .zero)
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Setup
  
  private func setupViews() {
    imageView.setSquareAspectRatio(sideLength: k.Sizes.tournamentCellWidth)
    secondaryLabel.font = secondaryLabel.font.withSize(secondaryLabel.font.pointSize - 5)
    
    let spacerView = UIView(frame: .zero)
    spacerView.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .vertical)
    
    let stackView = UIStackView()
    stackView.setup(
      subviews: [imageView, primaryLabel, secondaryLabel, spacerView],
      axis: .vertical,
      alignment: .fill,
      spacing: 5.0
    )
    
    contentView.addSubview(stackView)
    stackView.setEdgeConstraints(
      top: contentView.topAnchor,
      bottom: contentView.bottomAnchor,
      leading: contentView.leadingAnchor,
      trailing: contentView.trailingAnchor
    )
  }
  
  // MARK: Public Methods
  
  func setLabelsStyle() {
    primaryLabel.textAlignment = .left
    primaryLabel.font = UIFont.boldSystemFont(ofSize: primaryLabel.font.pointSize)
    primaryLabel.numberOfLines = 2
    secondaryLabel.numberOfLines = 3
  }
  
  func invalidateImage() {
    imageView.image = nil
  }
  
  func updateView(text: String?, imageURL: String?, detailText: String?) {
    primaryLabel.text = text
    secondaryLabel.text = detailText
    
    imageView.layer.cornerRadius = k.Sizes.cornerRadius
    imageView.layer.masksToBounds = true
    let newSize = CGSize(width: k.Sizes.tournamentListCellHeight, height: k.Sizes.tournamentListCellHeight)
    ImageService.getImage(imageUrl: imageURL, cache: .viewAllTournaments, newSize: newSize) { [weak self] (image) in
      let image = image ?? UIImage(named: "game-controller-square")
      DispatchQueue.main.async {
        guard let imageView = self?.imageView else { return }
        // FIXME: This cell sometimes displays the wrong image, due to the closure holding a reference to the cell,
        //        and how cells are reused (explanation here: https://stackoverflow.com/a/42916541)
        //        This issue was fixed for TournamentListVC, but a different solution is needed for MainVC, as it has multiple sections
        UIView.transition(with: imageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self?.imageView.image = image
        }, completion: nil)
      }
    }
  }
}
