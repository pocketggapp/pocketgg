import SwiftUI

enum AsyncImageViewState {
  case uninitialized
  case loading
  case loaded(UIImage)
  case error
}

struct AsyncImageView: View {
  @StateObject private var viewModel: AsyncImageViewModel
  private let imageURL: String?
  private let cornerRadius: CGFloat
  
  init(
    imageURL: String?,
    cornerRadius: CGFloat
  ) {
    self._viewModel = StateObject(wrappedValue: {
      AsyncImageViewModel(imageURL: imageURL)
    }())
    self.imageURL = imageURL
    self.cornerRadius = cornerRadius
  }
  
  var body: some View {
    switch viewModel.state {
    case .uninitialized, .loading:
      Rectangle()
        .fill(Color(.placeholder))
        .cornerRadius(cornerRadius)
    case .loaded(let image):
      Image(uiImage: image)
        .resizable()
        .scaledToFill()
        .cornerRadius(cornerRadius)
    case .error:
      Image(systemName: "gamecontroller")
        .resizable()
        .scaledToFit()
        .cornerRadius(cornerRadius)
    }
  }
}

class AsyncImageViewModel: ObservableObject {
  @Published var state: AsyncImageViewState
  
  init(imageURL: String?) {
    self.state = .uninitialized
    Task {
      await loadImage(imageURL)
    }
  }
  
  @MainActor
  func loadImage(_ url: String?) async {
    guard let url else {
      state = .error
      return
    }
    
    state = .loading
    let image = await ImageService.getImage(imageUrl: url)
    if let image {
      state = .loaded(image)
    } else {
      state = .error
    }
  }
}
