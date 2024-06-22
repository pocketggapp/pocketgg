import SwiftUI

enum AsyncImageViewState {
  case uninitialized
  case loading
  case loaded(UIImage)
  case error
}

struct AsyncImageView: View {
  @StateObject private var viewModel: AsyncImageViewModel
  
  private let cornerRadius: CGFloat
  private let placeholderImageName: String
  
  init(
    imageURL: String?,
    cornerRadius: CGFloat,
    placeholderImageName: String = "gamecontroller",
    newSize: CGSize? = nil
  ) {
    self._viewModel = StateObject(wrappedValue: {
      AsyncImageViewModel(
        imageURL: imageURL,
        newSize: newSize
      )
    }())
    self.cornerRadius = cornerRadius
    self.placeholderImageName = placeholderImageName
  }
  
  var body: some View {
    switch viewModel.state {
    case .uninitialized, .loading:
      Rectangle()
        .fill(Color(.placeholder))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    case .loaded(let image):
      Image(uiImage: image)
        .resizable()
        .scaledToFill()
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    case .error:
      Image(systemName: placeholderImageName)
        .resizable()
        .scaledToFit()
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .fontWeight(.light)
    }
  }
}

class AsyncImageViewModel: ObservableObject {
  @Published var state: AsyncImageViewState
  
  init(imageURL: String?, newSize: CGSize? = nil) {
    self.state = .uninitialized
    Task {
      await loadImage(url: imageURL, newSize: newSize)
    }
  }
  
  @MainActor
  func loadImage(url: String?, newSize: CGSize?) async {
    guard let url else {
      state = .error
      return
    }
    
    state = .loading
    let image = await ImageService.getImage(imageUrl: url, newSize: newSize)
    if let image {
      state = .loaded(image)
    } else {
      state = .error
    }
  }
}
