import SwiftUI

struct LocationPreferenceView: View {
  @StateObject private var viewModel = LocationPreferenceViewModel()
  
  var body: some View {
    List {
      Section {
        Toggle(isOn: $viewModel.usingLocation) {
          Text("Use Location")
        }
      }
      
      if viewModel.usingLocation {
        Section {
          Button("Get Current Location", systemImage: "location.fill") {
            viewModel.getCurrentLocation()
          }
          
          if !viewModel.cityCountryString.isEmpty {
            Text("Location: " + viewModel.cityCountryString)
            
            HStack {
              Text("Distance: ")
              
              TextField(text: $viewModel.distanceString, prompt: Text("50")) {}
                .keyboardType(.numberPad)
              
              Picker(selection: $viewModel.selectedDistanceUnit) {
                ForEach(viewModel.distanceUnits, id: \.self) {
                  Text($0)
                }
              } label: {}
            }
          }
        }
      }
    }
    .navigationTitle("Location")
    .onDisappear {
      viewModel.onViewDisappear()
    }
    .overlay {
      if viewModel.gettingLocation {
        LoadingView()
      }
    }
    .alert("Error", isPresented: $viewModel.showingAlert, actions: {
      Button("OK", role: .cancel) {}
    }, message: {
      Text(viewModel.error?.localizedDescription ?? "")
    })
  }
}

#Preview {
  LocationPreferenceView()
}
