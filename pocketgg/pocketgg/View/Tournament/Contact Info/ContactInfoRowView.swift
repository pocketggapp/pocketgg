import SwiftUI

struct ContactInfoRowView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let contactInfo: String
  private let contactType: String
  
  init(contactInfo: String, contactType: String) {
    self.contactInfo = contactInfo
    self.contactType = contactType
  }
  
  var imageName: String {
    switch contactType {
    case "email": return "envelope"
    case "discord": return "bubble.left.and.bubble.right"
    default: return "person.text.rectangle"
    }
  }
  
  var body: some View {
    ZStack {
      Color(UIColor.systemBackground)
      
      HStack {
        Image(systemName: imageName)
          .resizable()
          .scaledToFit()
          .frame(width: 44 * scale, height: 44 * scale)
        
        Text(contactInfo)
          .font(.body)
        
        Spacer()
      }
    }
    .onTapGesture {
      let urlPrefix = contactType == "email" ? "mailto:" : ""
      if let url = URL(string: "\(urlPrefix)\(contactInfo)") {
        UIApplication.shared.open(url)
      }
    }
  }
}

#Preview {
  ContactInfoRowView(
    contactInfo: "hello@genesisgaming.gg",
    contactType: "email"
  )
}
