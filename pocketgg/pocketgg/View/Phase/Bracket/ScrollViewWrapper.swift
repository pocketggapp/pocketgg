import SwiftUI

struct ScrollViewWrapper<Content: View>: UIViewRepresentable {
  private let content: () -> Content
  private let hostingController: UIHostingController<Content>
  
  init(@ViewBuilder _ content: @escaping () -> Content) {
    self.content = content
    self.hostingController = UIHostingController(rootView: content())
  }
  
  func makeUIView(context: UIViewRepresentableContext<ScrollViewWrapper>) -> UIScrollView {
    let scrollView = UIScrollView()
    scrollView.delegate = context.coordinator
    scrollView.maximumZoomScale = 2
    scrollView.minimumZoomScale = 0.5
    
    hostingController.view.sizeToFit()
    
    scrollView.addSubview(hostingController.view)
    scrollView.contentSize = hostingController.view.bounds.size
    
    return scrollView
  }
  
  func updateUIView(_ uiView: UIScrollView, context: UIViewRepresentableContext<ScrollViewWrapper>) { }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(hostingController: hostingController)
  }
  
  class Coordinator: NSObject, UIScrollViewDelegate {
    private let hostingController: UIHostingController<Content>
    
    init(hostingController: UIHostingController<Content>) {
      self.hostingController = hostingController
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return hostingController.view
    }
  }
}
