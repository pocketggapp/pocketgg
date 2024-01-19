import SwiftUI

enum AsyncImageViewState {
  case uninitialized
  case loading
  case loaded(UIImage)
  case error
}

struct AsyncImageView: View {
  @StateObject private var viewModel: AsyncImageViewModel
  private var imageURL: String
  
  init(imageURL: String) {
    self._viewModel = StateObject(wrappedValue: { AsyncImageViewModel(imageURL: imageURL) }())
    self.imageURL = imageURL
  }
  
  var body: some View {
    switch viewModel.state {
    case .uninitialized, .loading:
      Rectangle()
        .fill(Color(.placeholder))
        .cornerRadius(10)
        .aspectRatio(1, contentMode: .fit)
    case .loaded(let image):
      Image(uiImage: image)
        .resizable()
        .scaledToFill()
    case .error:
      Image(systemName: "gamecontroller")
        .resizable()
        .scaledToFit()
    }
  }
}

class AsyncImageViewModel: ObservableObject {
  @Published var state: AsyncImageViewState
  
  init(imageURL: String) {
    self.state = .uninitialized
    Task {
      await loadImage(imageURL)
    }
  }
  
  @MainActor
  func loadImage(_ url: String) async {
    state = .loading
    let image = await ImageService.getImage(imageUrl: url)
    if let image {
      state = .loaded(image)
    } else {
      state = .error
    }
  }
}
