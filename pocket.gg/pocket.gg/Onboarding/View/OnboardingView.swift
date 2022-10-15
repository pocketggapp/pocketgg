//
//  OnboardingView.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2022-02-10.
//  Copyright © 2022 Gabriel Siu. All rights reserved.
//

import SwiftUI

enum OnboardingFlowType {
  case firstTimeOnboarding
  case appUpdated
}

struct OnboardingView: View {

  let viewModel: OnboardingViewModel<AnyHashable>
  let flowType: OnboardingFlowType

  @State private var currentIndex = 0
  @State private var selectedItems = Set<VideoGame>()

  var body: some View {
    VStack {
      HStack {
        // Back Button
        if currentIndex != 0 {
          Button {
            if let index = viewModel.prevIndex() {
              withAnimation {
                currentIndex = index
              }
            }
          } label: {
            Image(systemName: "chevron.left")
              .foregroundColor(Color(.label))
          }
        }

        Spacer()

        // Skip Button
        Button {
          if flowType == .firstTimeOnboarding {
            let selectedGames = Array(selectedItems)
            MainVCDataService.updateEnabledGames(selectedGames)
            StartupTasksService.newUserOnboarding(selectedGames.map { $0.id })
          }

          guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
          guard let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
          guard let window = sceneDelegate.window else { return }
          // Reset UITableView background color, as it was changed if SelectionView is part of the onboarding flow
          UITableView.appearance().backgroundColor = .systemGroupedBackground
          window.rootViewController = MainTabBarControllerService.initTabBarController()
          window.makeKeyAndVisible()
        } label: {
          Text("Skip")
            .foregroundColor(.red)
        }
      }
      .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))

      PagerView(pageCount: viewModel.numPages, currentPageIndex: $currentIndex) {
        ForEach(viewModel.content, id: \.self) { page in
          if let page = page as? OnboardingContent {
            OnboardingPageView(title: page.title, subtitle: page.subtitle,
                               imageName: page.imageName, imagePadding: page.imagePadding)
          } else if let page = page as? SelectionContent {
            SelectionView(title: page.title, subtitle: page.subtitle, items: page.items, selectedItems: $selectedItems)
          } else if let page = page as? TextContent {
            TextView(title: page.title, message: page.message)
          }
        }
      }

      // Next/Done Button
      Button(action: {
        if let index = viewModel.nextIndex() {
          withAnimation {
            currentIndex = index
          }
        } else {
          if flowType == .firstTimeOnboarding, currentIndex == viewModel.numPages - 1 {
            let selectedGames = Array(selectedItems)
            MainVCDataService.updateEnabledGames(selectedGames)
            StartupTasksService.newUserOnboarding(selectedGames.map { $0.id })
          }

          guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
          guard let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
          guard let window = sceneDelegate.window else { return }
          // Reset UITableView background color, as it was changed if SelectionView is part of the onboarding flow
          UITableView.appearance().backgroundColor = .systemGroupedBackground
          window.rootViewController = MainTabBarControllerService.initTabBarController()
          window.makeKeyAndVisible()
        }
      }, label: {
        Text(currentIndex == viewModel.numPages - 1 ? "Done" : "Next")
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.red)
          .foregroundColor(.white)
          .cornerRadius(10)
          .padding([.leading, .trailing, .bottom], 16)
      })
    }
  }
}
