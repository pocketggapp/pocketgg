import SwiftUI

struct EliminationSetPathView: Shape {
  private let numPrecedingSets: Int
  
  init(numPrecedingSets: Int) {
    self.numPrecedingSets = numPrecedingSets
  }
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    if numPrecedingSets == 1 {
      path.move(to: CGPoint(x: rect.minX, y: rect.maxY / 2))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY / 2))
    } else if numPrecedingSets == 2 {
      let offset = rect.maxY / 6
      // 1
      path.move(to: CGPoint(x: rect.minX, y: offset))
      path.addLine(to: CGPoint(x: rect.width / 2, y: offset))

      // 2
      path.move(to: CGPoint(x: rect.minX, y: rect.maxY - offset))
      path.addLine(to: CGPoint(x: rect.width / 2, y: rect.maxY - offset))
      
      // 3
      path.move(to: CGPoint(x: rect.width / 2, y: offset))
      path.addLine(to: CGPoint(x: rect.width / 2, y: rect.maxY - offset))
      
      // 4
      path.move(to: CGPoint(x: rect.width / 2, y: rect.height / 2))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.height / 2))
    }
    
    return path
  }
}

#Preview {
  EliminationSetPathView(numPrecedingSets: 2)
    .stroke(style: .init(lineWidth: 3, lineCap: .round))
    .fill(Color(uiColor: UIColor.systemGray3))
}
