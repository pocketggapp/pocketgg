import SwiftUI

struct EditHomeView: View {
  var body: some View {
    NavigationStack {
      List {
        Section {
          NavigationLink {
            LocationView()
          } label: {
            HStack {
              Image(systemName: "location.fill")
              
              Text("Location")
            }
          }
        }
      }
    }
    .navigationTitle("Edit")
  }
}

#Preview {
  EditHomeView()
}
