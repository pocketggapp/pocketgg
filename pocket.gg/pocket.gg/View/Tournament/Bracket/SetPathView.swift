//
//  SetPathView.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-12-05.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

final class SetPathView: UIView {
  
  private let numPrecedingSets: Int
  private let line = CAShapeLayer()
  
  // MARK: Initialization
  
  init(numPrecedingSets: Int) {
    self.numPrecedingSets = numPrecedingSets
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Drawing
  
  override func draw(_ rect: CGRect) {
    let linePath = UIBezierPath()
    let setIdentifierOffset = k.Sizes.setHeight / 4
    
    if numPrecedingSets == 1 {
      linePath.move(to: CGPoint(x: rect.minX, y: rect.minY + floor(k.Sizes.setHeight / 2)))
      linePath.addLine(to: CGPoint(x: rect.maxX - setIdentifierOffset, y: rect.minY + floor(k.Sizes.setHeight / 2)))
    } else if numPrecedingSets == 2 {
      // 1
      linePath.move(to: CGPoint(x: rect.minX, y: rect.minY + floor(k.Sizes.setHeight / 2)))
      linePath.addLine(to: CGPoint(x: rect.minX + floor(rect.width / 2), y: rect.minY + floor(k.Sizes.setHeight / 2)))

      // 2
      linePath.move(to: CGPoint(x: rect.minX, y: rect.maxY - floor(k.Sizes.setHeight / 2)))
      linePath.addLine(to: CGPoint(x: rect.minX + floor(rect.width / 2), y: rect.maxY - floor(k.Sizes.setHeight / 2)))
      
      // 3
      linePath.move(to: CGPoint(x: rect.minX + floor(rect.width / 2), y: rect.minY + floor(k.Sizes.setHeight / 2)))
      linePath.addLine(to: CGPoint(x: rect.minX + floor(rect.width / 2), y: rect.maxY - floor(k.Sizes.setHeight / 2)))
      
      // 4
      linePath.move(to: CGPoint(x: rect.minX + floor(rect.width / 2), y: rect.minY + floor(rect.height / 2)))
      linePath.addLine(to: CGPoint(x: rect.maxX - setIdentifierOffset, y: rect.minY + floor(rect.height / 2)))
    }
    
    line.path = linePath.cgPath
    line.strokeColor = UIColor.systemGray3.cgColor
    line.lineWidth = 3
    line.lineCap = .round
    layer.addSublayer(line)
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    line.strokeColor = UIColor.systemGray3.cgColor
  }
}
