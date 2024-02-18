import SwiftUI

struct AsyncBannerImageView: View {
  @StateObject private var viewModel: AsyncImageViewModel
  
  private let imageURL: String?
  private let imageRatio: Double?
  
  init(
    imageURL: String?,
    imageRatio: Double?
  ) {
    self._viewModel = StateObject(wrappedValue: {
      AsyncImageViewModel(imageURL: imageURL)
    }())
    self.imageURL = imageURL
    self.imageRatio = imageRatio
  }
  
  var body: some View {
    switch viewModel.state {
    case .uninitialized, .loading, .error:
      Rectangle()
        .fill(Color(.placeholder))
    case .loaded(let image):
      Image(uiImage: image)
        .resizable()
        .aspectRatio(imageRatio ?? 4, contentMode: .fill)
    }
  }
}

#Preview {
  AsyncBannerImageView(
    imageURL: "https://images.start.gg/images/user/145926/image-747d2cfda61a2cf1d08699971e4ca989.png?ehk=2yJDN%2FtdJMFV%2FVA1NgU8D6m6r3T85OHo4pmVCdEP5pY%3D&ehkOptimized=szJt7wSUXoRptXhbtcF55NpHXSgPIVjP5FHJKoqsj1k%3D",
    imageRatio: 4
  )
  .frame(height: 150)
}
