import SwiftUI

struct SegmentedControlView: View {
  @Namespace var animation
  @Binding private var selected: String
  
  private let sections: [String]
  private let feedbackGenerator = UISelectionFeedbackGenerator()
  
  init(selected: Binding<String>, sections: [String]) {
    self._selected = selected
    self.sections = sections
  }
  
  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 0) {
        ForEach(sections, id: \.self) { section in
          Button {
            selected = section
            feedbackGenerator.selectionChanged()
          } label: {
            VStack {
              Text(section)
              
              ZStack {
                Rectangle()
                  .fill(Color.clear)
                  .frame(height: 2)
                if selected == section {
                  Rectangle()
                    .fill(Color.red)
                    .frame(height: 2)
                    .matchedGeometryEffect(id: "Section", in: animation)
                    .transition(.offset())
                }
              }
            }
          }
          .buttonStyle(SegmentedControlViewStyle())
        }
      }
    }
    .scrollIndicators(.hidden)
  }
}

private struct SegmentedControlViewStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration
      .label
      .padding(EdgeInsets(top: 14, leading: 20, bottom: 0, trailing: 20))
      .background(configuration.isPressed ? Color(uiColor: UIColor.systemGray4).opacity(0.5) : Color.clear)
  }
}

#Preview {
  struct ContainerView: View {
    @State var selected = "Events"
    var body: some View {
      SegmentedControlView(selected: $selected, sections: ["Events", "Streams", "Location", "Info"])
    }
  }
  return ContainerView()
}
