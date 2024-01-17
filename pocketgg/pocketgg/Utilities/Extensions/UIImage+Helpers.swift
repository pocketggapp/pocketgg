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
  
  func cropToRatio(_ newRatio: CGFloat, from oldRatio: CGFloat) -> UIImage {
    // If original image is more wide, then cropped version should retain the existing height
    // If original image is more tall, then cropped version should retain the existing width
    let newWidth  = newRatio > oldRatio ?                        size.width : size.width * newRatio / oldRatio
    let newHeight = newRatio > oldRatio ? size.height * newRatio / oldRatio : size.height
    let newX      = newRatio > oldRatio ?                                 0 : (size.width - newWidth) / 2
    let newY      = newRatio > oldRatio ?    -(size.height - newHeight) / 2 : 0
    
    guard let cropped = cgImage?.cropping(to: CGRect(x: newX, y: newY, width: newWidth, height: newHeight)) else { return self }
    return UIImage(cgImage: cropped)
  }
}
