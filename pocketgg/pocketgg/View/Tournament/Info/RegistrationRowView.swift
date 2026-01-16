import SwiftUI

struct RegistrationRowView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let tournamentSlug: String?
  private let registrationOpen: Bool
  private let registrationCloseDate: String
  
  init(
    tournamentSlug: String?,
    registrationOpen: Bool,
    registrationCloseDate: String
  ) {
    self.tournamentSlug = tournamentSlug
    self.registrationOpen = registrationOpen
    self.registrationCloseDate = registrationCloseDate
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Registration")
        .font(.title3.bold())
      
      Button {
        openRegistrationPage()
      } label: {
        ZStack {
          Color(UIColor.systemBackground)
          
          HStack {
            Image(systemName: "cart.badge.plus")
              .resizable()
              .scaledToFit()
              .frame(width: 44 * scale, height: 44 * scale)
              .fontWeight(.light)
            
            registrationTextView
            
            Spacer()
            
            Image(systemName: "chevron.right")
              .foregroundStyle(.gray)
          }
        }
      }
      .buttonStyle(.plain)
      .disabled(!registrationOpen)
    }
  }
  
  private var registrationTextView: some View {
    VStack(alignment: .leading) {
      registrationOpen
        ? Text("Register").foregroundStyle(.blue)
        : Text("Registration not available")
      
      Text("Close\(registrationOpen ? "s" : "d") on " + registrationCloseDate)
        .font(.caption)
    }
  }
  
  private func openRegistrationPage() {
    guard let tournamentSlug else { return }
    guard let url = URL(string: "https://start.gg/\(tournamentSlug)/register") else { return }
    UIApplication.shared.open(url)
  }
}

#Preview {
  RegistrationRowView(
    tournamentSlug: "tournament/the-big-house-6",
    registrationOpen: true,
    registrationCloseDate: "January 1, 1970"
  )
}
