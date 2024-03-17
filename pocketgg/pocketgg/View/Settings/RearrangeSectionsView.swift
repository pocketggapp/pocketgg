import SwiftUI

struct RearrangeSectionsView: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @ScaledMetric private var scale: CGFloat = 1
  
  @StateObject private var viewModel: RearrangeSectionsViewModel
  @State private var currentlyDragging: HomeViewSection?
  
  init() {
    self._viewModel = StateObject(wrappedValue: { RearrangeSectionsViewModel() }())
  }
  
  var body: some View {
    let layout = horizontalSizeClass == .regular
      ? AnyLayout(HStackLayout(alignment: .top))
      : AnyLayout(VStackLayout())
    
    ZStack {
      Color(uiColor: .secondarySystemBackground)
        .ignoresSafeArea()
      
      ScrollView(.vertical) {
        VStack(alignment: .leading) {
          layout {
            SectionsView(enabled: true)
            
            SectionsView(enabled: false)
          }
          
          Divider()
            .padding(.bottom)
          
          Text("Drag sections to Enabled to show them on the main screen, and drag them to Disabled to hide them. Disabling a video game will also remove it from Video Game Selection")
            .font(.subheadline)
        }
        .padding(.horizontal)
      }
    }
    .onAppear {
      viewModel.initializeSections()
      viewModel.resetHomeViewRefreshNotification()
    }
    .navigationTitle("Rearrange Sections")
  }
  
  // MARK: ViewBuilders
  
  @ViewBuilder
  private func SectionsView(enabled: Bool) -> some View {
    VStack {
      HStack {
        Text(enabled ? "Enabled" : "Disabled")
          .font(.title2.bold())
        Spacer()
      }
      
      SectionListView(
        sections: enabled ? viewModel.enabledSections : viewModel.disabledSections,
        enabled: enabled
      )
    }
    .frame(maxWidth: .infinity)
    .contentShape(.rect)
    .dropDestination(for: HomeViewSection.self) { items, location in
      withAnimation(.snappy) {
        viewModel.appendSection(
          currentlyDragging: currentlyDragging,
          enabled: enabled
        )
        viewModel.updateHomeViewLayout()
      }
      return true
    }
  }
  
  @ViewBuilder
  private func SectionListView(sections: [HomeViewSection], enabled: Bool) -> some View {
    VStack(alignment: .leading, spacing: 10) {
      if !sections.isEmpty {
        ForEach(sections, id: \.id) {
          DraggableSectionRowView($0)
        }
        Color(uiColor: .secondarySystemBackground)
      } else {
        EmptyListView(enabled: enabled)
      }
    }
  }
  
  @ViewBuilder
  private func DraggableSectionRowView(_ section: HomeViewSection) -> some View {
    SectionRowView(section)
      .draggable(section) {
        SectionRowView(section)
          .onAppear {
            currentlyDragging = section
          }
      }
      .dropDestination(for: HomeViewSection.self) { items, location in
        currentlyDragging = nil
        return false
      } isTargeted: { status in
        if let currentlyDragging, status, currentlyDragging.id != section.id {
          withAnimation(.snappy) {
            viewModel.appendSection(
              currentlyDragging: currentlyDragging,
              enabled: section.enabled
            )
            viewModel.rearrangeSection(
              currentlyDragging: currentlyDragging,
              droppingSection: section,
              enabled: section.enabled
            )
            viewModel.updateHomeViewLayout()
          }
        }
      }
  }
  
  @ViewBuilder
  private func SectionRowView(_ section: HomeViewSection) -> some View {
    HStack {
      if let imageName = section.imageName {
        Image(systemName: imageName)
          .foregroundColor(.red)
          .frame(width: 30 * scale, height: 30 * scale)
      }
      Text(section.name)
    }
    .padding(.horizontal)
    .frame(maxWidth: .infinity, alignment: .leading)
    .frame(height: 44 * scale)
    .background(in: .rect(cornerRadius: 5))
    .contentShape(.dragPreview, .rect(cornerRadius: 5))
  }
  
  @ViewBuilder
  private func EmptyListView(enabled: Bool) -> some View {
    ZStack(alignment: .center) {
      RoundedRectangle(cornerRadius: 5)
        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
      
      HStack {
        Image(systemName: "plus.circle")
        Text("Drag sections here to \(enabled ? "show them on" : "hide them from") the main screen")
          .font(.callout)
      }
      .padding()
    }
    .foregroundColor(.gray)
  }
}

#Preview {
  RearrangeSectionsView()
}
