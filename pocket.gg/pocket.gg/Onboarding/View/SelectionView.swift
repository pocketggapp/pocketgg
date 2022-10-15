//
//  SelectionView.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2022-03-01.
//  Copyright © 2022 Gabriel Siu. All rights reserved.
//

import SwiftUI

struct SelectionView: View {

  let title: String
  let subtitle: String
  let items: [VideoGame]

  @State private var editMode = EditMode.active
  @Binding private var selectedItems: Set<VideoGame>

  init(title: String, subtitle: String, items: [VideoGame], selectedItems: Binding<Set<VideoGame>>) {
    self.title = title
    self.subtitle = subtitle
    self.items = items
    self._selectedItems = selectedItems
    UITableView.appearance().backgroundColor = .clear
  }

  var body: some View {
    VStack {
      List(items, id: \.self, selection: $selectedItems) { videoGame in
        Text(videoGame.name)
      }
      .environment(\.editMode, $editMode)
      Text(title)
        .font(.system(.title))
        .bold()
        .multilineTextAlignment(.center)
      Text(subtitle)
        .font(.system(.subheadline))
        .multilineTextAlignment(.center)
        .foregroundColor(.secondary)
    }
    .padding([.leading, .trailing], 25)
  }
}
