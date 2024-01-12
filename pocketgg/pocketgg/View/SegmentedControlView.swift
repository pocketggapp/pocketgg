import SwiftUI

struct SegmentedControlView: View {
  @Namespace var animation
  @Binding var selected: String
  let sections: [String]
  
  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 0) {
        ForEach(sections, id: \.self) { section in
          Button {
            selected = section
          } label: {
            VStack {
              Text(section)
                .font(.subheadline)
                .foregroundStyle(.primary)
              ZStack {
                Rectangle()
                  .fill(Color.clear)
                  .frame(height: 2)
                if selected == section {
                  Rectangle()
                    .fill(Color.red)
                    .frame(height: 2)
                    .matchedGeometryEffect(id: "Section", in: animation)
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
      .background(configuration.isPressed ? Color(red: 0.808, green: 0.831, blue: 0.855, opacity: 0.5) : Color.clear)
  }
}

#Preview {
  @State var selected = "Events"
  return SegmentedControlView(selected: $selected, sections: ["Events", "Streams", "Location", "Contact Info"])
}
