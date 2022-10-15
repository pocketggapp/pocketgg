//
//  OnboardingViewModel.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2022-02-27.
//  Copyright © 2022 Gabriel Siu. All rights reserved.
//

class OnboardingViewModel<T: Hashable> {
  private(set) var content: [T]
  private var currentPageIndex: Int
  var numPages: Int { content.count }

  init(content: [Any]) {
    self.currentPageIndex = 0
    self.content = content.compactMap {
      if $0.self is AnyHashable, let hashableContent = $0 as? T {
        return hashableContent
      } else {
        return nil
      }
    }
  }

  func prevIndex() -> Int? {
    guard currentPageIndex > 0 else { return nil }
    currentPageIndex -= 1
    return currentPageIndex
  }

  func nextIndex() -> Int? {
    guard currentPageIndex < numPages - 1 else { return nil }
    currentPageIndex += 1
    return currentPageIndex
  }
}
