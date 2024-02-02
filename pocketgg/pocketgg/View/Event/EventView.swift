import SwiftUI

struct EventView: View {
  @ScaledMetric private var scale: CGFloat = 1
  @StateObject private var viewModel: EventViewModel
  private let event: Event
  
  init(_ event: Event) {
    self.event = event
    self._viewModel = StateObject(wrappedValue: {
      EventViewModel(event)
    }())
  }
  
  var body: some View {
    List {
      Section {
        headerView
      } header: {
        Text("Summary")
      }
      
      Section {
        // TODO: Brackets
        Text("handland")
      } header: {
        Text("Brackets")
      }
      
      Section {
        // TODO: Standings
        Text("handland")
      } header: {
        Text("Standings")
      }
    }
    .listStyle(.insetGrouped)
    .navigationTitle(event.name ?? "")
  }
  
  private var headerView: some View {
    HStack {
      AsyncImageView(
        imageURL: event.videogameImage ?? "",
        cornerRadius: 5
      )
      .frame(width: 54 * scale, height: 72 * scale)
      .clipped()
      
      VStack(alignment: .leading) {
        Text(event.name ?? "")
          .font(.headline)
        
        subtitleTextView
          .font(.caption)
      }
      
      Spacer()
    }
  }
  
  private var subtitleTextView: some View {
    return Text(event.eventType ?? "") + Text(" • ") + Text(event.videogameName ?? "")
    + Text("\n") + Text("● ").foregroundColor(viewModel.headerDotColor) + Text(event.startDate ?? "")
  }
}

#Preview {
  EventView(MockStartggService.createEvent())
}
