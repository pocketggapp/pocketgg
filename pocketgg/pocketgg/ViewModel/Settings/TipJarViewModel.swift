import StoreKit

enum TipJarViewState {
  case uninitialized
  case loaded([Product])
}

@MainActor
final class TipJarViewModel: ObservableObject {
  @Published var state: TipJarViewState
  @Published private(set) var activeTransactions: Set<Transaction>
  
  private var updates: Task<Void, Never>?
  
  init() {
    self.state = .uninitialized
    self.activeTransactions = []
    
    self.updates = Task {
      for await update in StoreKit.Transaction.updates {
        if let transaction = try? update.payloadValue {
          await fetchActiveTransactions()
          await transaction.finish()
        }
      }
    }
  }
  
  deinit {
    updates?.cancel()
  }
  
  func fetchProducts() async {
    do {
      let products = try await Product.products(
        for: [
          "tip.coffee",
          "tip.snack",
          "tip.lunch"
        ]
      ).sorted(by: { $0.price < $1.price })
      
      state = .loaded(products)
    } catch {
      state = .loaded([])
    }
  }
  
  func fetchActiveTransactions() async {
    var activeTransactions: Set<StoreKit.Transaction> = []
    
    for await entitlement in StoreKit.Transaction.currentEntitlements {
      if let transaction = try? entitlement.payloadValue {
        activeTransactions.insert(transaction)
      }
    }
    
    self.activeTransactions = activeTransactions
  }
  
  func purchase(_ product: Product) async throws {
    let result = try await product.purchase()
    switch result {
    case .success(let verificationResult):
      if let transaction = try? verificationResult.payloadValue {
        activeTransactions.insert(transaction)
        await transaction.finish()
      }
    default:
      break
    }
  }
}
