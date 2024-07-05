import SwiftUI

struct AsyncBannerImageView: View {
  @ScaledMetric private var scale: CGFloat = 1
  @StateObject private var viewModel: AsyncImageViewModel
  
  private let imageURL: String?
  private let imageRatio: Double?
  private let placeholderImageName: String?
  
  init(
    imageURL: String?,
    imageRatio: Double?,
    placeholderImageName: String? = nil
  ) {
    self._viewModel = StateObject(wrappedValue: {
      AsyncImageViewModel(imageURL: imageURL)
    }())
    self.imageURL = imageURL
    self.imageRatio = imageRatio
    self.placeholderImageName = placeholderImageName
  }
  
  var body: some View {
    switch viewModel.state {
    case .uninitialized, .loading:
      Rectangle()
        .fill(Color(.placeholder))
    case .loaded(let image):
      Image(uiImage: image)
        .resizable()
        .aspectRatio(imageRatio ?? 4, contentMode: .fill)
    case .error:
      Rectangle()
        .fill(Color(.placeholder))
        .overlay {
          Image(systemName: placeholderImageName ?? "")
            .resizable()
            .frame(width: 50 * scale, height: 50 * scale)
        }
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
