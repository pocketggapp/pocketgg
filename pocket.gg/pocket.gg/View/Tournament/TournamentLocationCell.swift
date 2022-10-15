//
//  TournamentLocationCell.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-03-06.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit
import MapKit

final class TournamentLocationCell: UITableViewCell {
    
  private let spinner = UIActivityIndicatorView(style: .medium)
  private let mapPreviewImageView = UIImageView()
  private let imageKeyPortrait: String
  private let imageKeyLandscape: String
  private let latitude: Double
  private let longitude: Double
  private var isPortrait: Bool {
    return UIScreen.main.bounds.width < UIScreen.main.bounds.height
  }
  
  // MARK: - Initialization
  
  init(id: Int, latitude: Double, longitude: Double) {
    imageKeyPortrait = "mapPreview\(id)-portrait"
    imageKeyLandscape = "mapPreview\(id)-landscape"
    self.latitude = latitude
    self.longitude = longitude
    super.init(style: .default, reuseIdentifier: nil)
    
    selectionStyle = .none
    setupCell()
    
    let imageKey = isPortrait ? imageKeyPortrait : imageKeyLandscape
    if let image = ImageService.getCachedImage(with: imageKey) {
      mapPreviewImageView.image = image
    } else {
      getMapPreviews()
    }
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: UI Setup
  
  private func setupCell() {
      contentView.addSubview(spinner)
      contentView.addSubview(mapPreviewImageView)
      mapPreviewImageView.contentMode = .scaleAspectFit
      mapPreviewImageView.setEdgeConstraints(
        top: contentView.topAnchor,
        bottom: contentView.bottomAnchor,
        leading: contentView.leadingAnchor,
        trailing: contentView.trailingAnchor
      )
      spinner.setAxisConstraints(xAnchor: contentView.centerXAnchor, yAnchor: contentView.centerYAnchor)
  }
  
  private func getMapPreviews() {
    spinner.startAnimating()
    
    // Set up the MKMapSnapshotter to capture the location of the tournament
    let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    let distanceInMeters: Double = 1000
    
    // Get the image of the location using the device's current width
    let options = MKMapSnapshotter.Options()
    options.region = MKCoordinateRegion(center: coordinates, latitudinalMeters: distanceInMeters, longitudinalMeters: distanceInMeters)
    options.size = CGSize(width: UIScreen.main.bounds.width, height: k.Sizes.mapHeight)
    
    let snapshotter = MKMapSnapshotter(options: options)
    snapshotter.start { [weak self] (snapshot, error) in
      guard error == nil else {
        self?.spinner.stopAnimating()
        return
      }
      guard let self = self else { return }
      
      let image = self.addPinToImage(size: options.size, snapshot: snapshot, coordinates: coordinates)
      
      if self.isPortrait {
        ImageService.saveImageToCache(image: image, with: self.imageKeyPortrait)
      } else {
        ImageService.saveImageToCache(image: image, with: self.imageKeyLandscape)
      }

      self.mapPreviewImageView.image = image
      self.spinner.stopAnimating()
    }
    
    // Get another image of the location, this time using the device's current height, for when the device changes orientation
    let options2 = MKMapSnapshotter.Options()
    options2.region = MKCoordinateRegion(center: coordinates, latitudinalMeters: distanceInMeters, longitudinalMeters: distanceInMeters)
    options2.size = CGSize(width: UIScreen.main.bounds.height, height: k.Sizes.mapHeight)

    let snapshotter2 = MKMapSnapshotter(options: options2)
    snapshotter2.start { [weak self] (snapshot, error) in
      guard error == nil else { return }
      guard let self = self else { return }

      let image = self.addPinToImage(size: options2.size, snapshot: snapshot, coordinates: coordinates)
      
      if self.isPortrait {
        ImageService.saveImageToCache(image: image, with: self.imageKeyLandscape)
      } else {
        ImageService.saveImageToCache(image: image, with: self.imageKeyPortrait)
      }
    }
  }
  
  // MARK: - Private Helpers
  
  private func addPinToImage(size: CGSize, snapshot: MKMapSnapshotter.Snapshot?, coordinates: CLLocationCoordinate2D) -> UIImage {
    return UIGraphicsImageRenderer(size: size).image { _ in
      snapshot?.image.draw(at: .zero)
      
      let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
      let pinImage = pinView.image
      
      if let point = snapshot?.point(for: coordinates) {
        let finalPoint = CGPoint(x: point.x + pinView.centerOffset.x - pinView.bounds.width / 2,
                                 y: point.y + pinView.centerOffset.y - pinView.bounds.height / 2)
        pinImage?.draw(at: finalPoint)
      }
    }
  }
  
  // MARK: Public Methods
  
  func updateImageForOrientation() {
    let imageKey = isPortrait ? imageKeyLandscape : imageKeyPortrait
    if let image = ImageService.getCachedImage(with: imageKey) {
      mapPreviewImageView.image = image
    }
  }
}
