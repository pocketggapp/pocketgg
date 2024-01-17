import SwiftUI

struct AsyncImageView: View {
  @StateObject private var viewModel: AsyncImageViewModel
  private var imageURL: String
  
  init(imageURL: String) {
    self._viewModel = StateObject(wrappedValue: { AsyncImageViewModel(imageURL: imageURL) }())
    self.imageURL = imageURL
  }
  
  var body: some View {
    if let image = viewModel.image {
      Image(uiImage: image)
        .resizable()
        .scaledToFill()
    } else {
      Image(systemName: "gamecontroller")
        .resizable()
        .scaledToFit()
    }
  }
}

class AsyncImageViewModel: ObservableObject {
  @Published var image: UIImage?
  
  init(imageURL: String) {
    Task {
      await loadImage(imageURL)
    }
  }
  
  @MainActor
  func loadImage(_ url: String) async {
    let image = await ImageService.getImage(imageUrl: url)
    self.image = image
  }
}
