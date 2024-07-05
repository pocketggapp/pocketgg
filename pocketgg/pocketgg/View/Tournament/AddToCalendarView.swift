import SwiftUI
import EventKitUI

struct AddToCalendarView: UIViewControllerRepresentable {
  @Environment(\.dismiss) private var dismiss
  
  let eventStore: EKEventStore?
  let event: EKEvent?
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<AddToCalendarView>) -> EKEventEditViewController {
    let eventEditViewController = EKEventEditViewController()
    eventEditViewController.eventStore = eventStore
    eventEditViewController.event = event
    eventEditViewController.editViewDelegate = context.coordinator
    return eventEditViewController
  }
  
  func updateUIViewController(_ uiViewController: EKEventEditViewController, context: UIViewControllerRepresentableContext<AddToCalendarView> ) { }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, EKEventEditViewDelegate {
    let parent: AddToCalendarView
    
    init(_ parent: AddToCalendarView) {
      self.parent = parent
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
      parent.dismiss()
    }
  }
}
