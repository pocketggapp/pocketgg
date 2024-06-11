import SwiftUI

struct TipJarView: View {
  @StateObject private var viewModel: TipJarViewModel
  
  init() {
    self._viewModel = StateObject(wrappedValue: { TipJarViewModel() }())
  }
  
  var body: some View {
    ScrollView(.vertical) {
      VStack(spacing: 24) {
        switch viewModel.state {
        case .uninitialized:
          ForEach(0..<3) { _ in
            TipOptionPlaceholderView()
          }
        case .loaded(let products):
          ForEach(products, id: \.id) { product in
            Button {
              Task {
                try await viewModel.purchase(product)
              }
            } label: {
              HStack {
                Text(verbatim: product.description)
                  .font(.title)
                
                Text(verbatim: product.displayName)
                  .font(.headline)
                
                Spacer()
                
                Text(verbatim: product.displayPrice)
              }
            }
            .buttonStyle(.bordered)
          }
        }
        
        Divider()
        
        Text("Thanks for using pocketgg! If you’re feeling extra generous and would like to support development of the app, feel free to use one of the buttons above ❤️")
          .font(.subheadline)
      }
      .padding()
    }
    .task {
      await viewModel.fetchProducts()
    }
    .navigationTitle("Tip Jar")
  }
}

#Preview {
  TipJarView()
}
