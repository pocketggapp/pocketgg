//
//  OnboardingPageView.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2022-02-10.
//  Copyright © 2022 Gabriel Siu. All rights reserved.
//

import SwiftUI

struct OnboardingPageView: View {
    let title: String
    let subtitle: String
    let imageName: String
    let imagePadding: CGFloat
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .padding(EdgeInsets(top: 0, leading: imagePadding,
                                    bottom: 0, trailing: imagePadding))
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
