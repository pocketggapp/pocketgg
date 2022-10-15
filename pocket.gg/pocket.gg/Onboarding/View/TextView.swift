//
//  TextView.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2022-03-09.
//  Copyright © 2022 Gabriel Siu. All rights reserved.
//

import SwiftUI

struct TextView: View {

  let title: String
  let message: String

  var body: some View {
    VStack {
      Text(title)
        .font(.system(.title))
        .bold()
        .multilineTextAlignment(.center)
      Text(message)
        .font(.system(.subheadline))
        .foregroundColor(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
    .padding([.leading, .trailing], 25)
  }
}
