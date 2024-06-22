import SwiftUI

struct LocationPreferenceView: View {
  @StateObject private var viewModel: LocationPreferenceViewModel
  
  init() {
    self._viewModel = StateObject(wrappedValue: {
      LocationPreferenceViewModel()
    }())
  }
  
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
      
      Section { } footer: {
        Text("Set your location to only load tournaments in your area. Featured tournaments and searching for tournaments do not take your location into account.")
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
    .alert("Allow Location Access", isPresented: $viewModel.showingLocationPermissionAlert, actions: {
      Button("OK", role: .cancel) {}
    }, message: {
      Text("To find tournaments in your area, please go to your device's settings and allow location access for pocketgg.")
    })
    .alert("Error", isPresented: $viewModel.showingAlert, actions: {
      Button("OK", role: .cancel) {}
    }, message: {
      Text(viewModel.error?.localizedDescription ?? "")
    })
    .scrollDismissesKeyboard(.immediately)
  }
}

#Preview {
  LocationPreferenceView()
}
