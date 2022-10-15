//
//  OnboardingContent.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2022-03-03.
//  Copyright © 2022 Gabriel Siu. All rights reserved.
//

import UIKit

struct OnboardingContent: Hashable {
  let title: String
  let subtitle: String
  let imageName: String
  let imagePadding: CGFloat
}

struct SelectionContent: Hashable {
  let title: String
  let subtitle: String
  let items: [VideoGame]
}

struct TextContent: Hashable {
  let title: String
  let message: String
}
