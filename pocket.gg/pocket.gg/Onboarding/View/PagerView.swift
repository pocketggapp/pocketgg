//
//  PagerView.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2022-02-27.
//  Adapted from https://gist.github.com/mecid/e0d4d6652ccc8b5737449a01ee8cbc6f
//

import SwiftUI

struct PagerView<Content: View>: View {
    @Binding var currentPageIndex: Int
    let pageCount: Int
    let content: Content
    
    init(pageCount: Int, currentPageIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._currentPageIndex = currentPageIndex
        self.pageCount = pageCount
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                content.frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(currentPageIndex) * geometry.size.width)
        }
    }
}
