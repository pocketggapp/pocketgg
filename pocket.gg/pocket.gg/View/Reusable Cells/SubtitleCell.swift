//
//  SubtitleCell.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-03-14.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

final class SubtitleCell: UITableViewCell {
    
    var imageViewFrame: CGRect?
    var textLabelFrame: CGRect?
    var detailTextLabelFrame: CGRect?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        imageView?.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let imageViewFrame = imageViewFrame {
            imageView?.frame = imageViewFrame
        } else {
            imageViewFrame = imageView?.frame
        }
        if let textLabelFrame = textLabelFrame {
            textLabel?.updateWidth(oldFrame: textLabelFrame, newFrame: textLabel?.frame)
        } else {
            textLabelFrame = textLabel?.frame
        }
        if let detailTextLabelFrame = detailTextLabelFrame {
            detailTextLabel?.updateWidth(oldFrame: detailTextLabelFrame, newFrame: detailTextLabel?.frame)
        } else {
            detailTextLabelFrame = detailTextLabel?.frame
        }
    }
    
    // MARK: - Public Methods
    
    func updateView(text: String?, imageInfo: (url: String?, ratio: Double?)?, detailText: String?, newRatio: CGFloat? = nil) {
        textLabel?.text = text
        detailTextLabel?.text = detailText
        
        imageView?.layer.cornerRadius = k.Sizes.cornerRadius
        imageView?.layer.masksToBounds = true
        ImageService.getImage(imageUrl: imageInfo?.url) { [weak self] (image) in
            guard let image = image else { return }
            var finalImage: UIImage?
            if let newRatio = newRatio, let prevRatio = imageInfo?.ratio {
                finalImage = image.cropToRatio(newRatio, from: CGFloat(prevRatio))
            } else {
                finalImage = image
            }
            DispatchQueue.main.async {
                self?.imageView?.image = finalImage
            }
        }
    }
}

private extension UILabel {
    func updateWidth(oldFrame: CGRect, newFrame: CGRect?) {
        if let newWidth = newFrame?.width, newWidth > oldFrame.width {
            frame = CGRect(x: frame.minX, y: frame.minY, width: newWidth, height: frame.height)
        } else {
            frame = oldFrame
        }
    }
}
