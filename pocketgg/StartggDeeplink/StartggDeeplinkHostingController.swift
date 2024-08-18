import SwiftUI

final class NavigationControllerVC: UINavigationController {
  init() {
    super.init(rootViewController: StartggDeeplinkHostingController())
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class StartggDeeplinkHostingController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissVC))
    
    let viewModel = StartggDeeplinkViewModel(extensionItem: extensionContext?.inputItems.first as? NSExtensionItem) { [weak self] in
      self?.openURL($0)
      self?.dismissVC()
    }
    let hostingView = UIHostingController(rootView: StartggDeeplinkView(viewModel: viewModel))
    
    addChild(hostingView)
    view.addSubview(hostingView.view)
    hostingView.view.translatesAutoresizingMaskIntoConstraints = false
    hostingView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    hostingView.view.bottomAnchor.constraint (equalTo: view.bottomAnchor).isActive = true
    hostingView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    hostingView.view.rightAnchor.constraint (equalTo: view.rightAnchor).isActive = true
  }
  
  @objc private func dismissVC() {
    extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
  }
}

extension UIViewController {
  func openURL(_ url: URL) {
    var responder: UIResponder? = self
    while responder != nil {
      if let application = responder as? UIApplication {
        application.open(url)
      }
      responder = responder?.next
    }
  }
}
