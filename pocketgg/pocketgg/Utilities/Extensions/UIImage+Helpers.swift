import UIKit

extension UIImage {
  func resize(toWidth width: CGFloat? = nil, toHeight height: CGFloat? = nil, toSize newSize: CGSize? = nil) -> UIImage {
    let finalSize: CGSize
    if let newSize = newSize {
      finalSize = newSize
    } else if let width = width {
      guard width < size.width else { return self }
      finalSize = CGSize(width: width, height: width * size.height / size.width)
    } else if let height = height {
      guard height < size.height else { return self }
      finalSize = CGSize(width: height * size.width / size.height, height: height)
    } else {
      return self
    }
    
    return UIGraphicsImageRenderer(size: CGSize(width: finalSize.width, height: finalSize.height)).image { _ in
      self.draw(in: CGRect(origin: .zero, size: CGSize(width: finalSize.width, height: finalSize.height)))
    }
  }
}
