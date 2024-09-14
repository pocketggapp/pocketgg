import SwiftUI

struct InlineTabsView: View {
  @Namespace private var tabSelectionAnimation
  @Binding var tabIndex: Int
  
  private var models: [InlineTabsModel]
  private let feedbackGenerator = UISelectionFeedbackGenerator()
  
  init(
    tabIndex: Binding<Int>,
    models: [InlineTabsModel]
  ) {
    self._tabIndex = tabIndex
    self.models = Array(models)
  }
  
  public var body: some View {
    HStack(alignment: .center, spacing: 0) {
      ForEach(Array(zip(models.indices, models)), id: \.0) { index, model in
        let isSelected = tabIndex == index
        GeometryReader { proxy in
          VStack(alignment: .center, spacing: 0) {
            Button {
              tabIndex = index
              feedbackGenerator.selectionChanged()
            } label: {
              textView(text: model.title, isSelected: isSelected)
            }
            
            let width = proxy.size.width
            let height = model.lineHeight(isSelected: tabIndex == index)
            if isSelected {
              bottomRect(in: .blue, width: width, height: height)
                .matchedGeometryEffect(id: "inlineTabSelected", in: tabSelectionAnimation)
            } else {
              bottomRect(in: .clear, width: width, height: height)
            }
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .fixedSize(horizontal: false, vertical: false)
          .border(width: 1, edges: [.bottom], color: Color(.separator))
          .animation(.easeInOut(duration: 0.2), value: tabIndex)
          .frame(maxWidth: .infinity)
          .contentShape(Rectangle())
        }
      }
    }
    .ignoresSafeArea(edges: .vertical)
    .frame(height: 48)
    .frame(maxWidth: .infinity)
    .fixedSize(horizontal: false, vertical: false)
  }
  
  private func textView(text: String, isSelected: Bool) -> some View {
    Text(text)
      .lineLimit(1)
      .font(.subheadline.weight(.semibold))
      .foregroundColor(isSelected ? .blue : Color(uiColor: .label))
      .padding(.horizontal, 16)
      .padding(.top, 12)
      .padding(.bottom, isSelected ? 15 : 16)
      .contentShape(Rectangle())
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
  }
  
  private func bottomRect(in color: Color, width: CGFloat, height: CGFloat) -> some View {
    Rectangle()
      .frame(width: width, height: height, alignment: .leading)
      .padding(.leading, 0)
      .foregroundColor(color)
  }
}


struct InlineTabsModel: Identifiable, Hashable {
  let id = UUID()
  let title: String
  
  init(title: String) {
    self.title = title
  }
  
  func lineHeight(isSelected: Bool) -> CGFloat {
    isSelected ? 2.0 : 1.0
  }
}

struct InlineTabsEdgeBorder: Shape {
  let width: CGFloat
  let edges: [Edge]
  
  func path(in rect: CGRect) -> Path {
    edges.map { edge -> Path in
      switch edge {
      case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
      case .bottom: return Path(.init(x: rect.minX, y: rect.maxY, width: rect.width, height: width))
      case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
      case .trailing: return Path(.init(x: rect.maxX, y: rect.minY, width: width, height: rect.height))
      }
    }.reduce(into: Path()) { $0.addPath($1) }
  }
}

extension View {
  func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
    overlay(InlineTabsEdgeBorder(width: width, edges: edges).foregroundColor(color))
  }
}

#Preview {
  struct ContainerView: View {
    @State var index = 0
    var body: some View {
      InlineTabsView(tabIndex: $index, models: [
        InlineTabsModel(title: "Events"),
        InlineTabsModel(title: "Streams"),
        InlineTabsModel(title: "Location"),
        InlineTabsModel(title: "Info")
      ])
    }
  }
  return ContainerView()
}
