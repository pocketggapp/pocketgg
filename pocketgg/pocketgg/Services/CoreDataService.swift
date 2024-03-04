import CoreData

// TODO: Mock Core Data Service
final class CoreDataService {
  static let shared = CoreDataService()
  
  let container: NSPersistentContainer
  let context: NSManagedObjectContext
  
  init() {
    container = NSPersistentContainer(name: "PocketggContainer")
    container.loadPersistentStores { description, error in
      if let error = error {
        #if DEBUG
        print("Error loading Core Data: \(error)")
        #endif
      }
    }
    context = container.viewContext
  }
  
  func save() {
    do {
      try context.save()
    } catch let error {
      #if DEBUG
      print("Error saving Core Data: \(error.localizedDescription)")
      #endif
    }
  }
}
