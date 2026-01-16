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
      } footer: {
        Text("Set your location to only load tournaments in your area. Featured tournaments and searching for tournaments do not take your location into account.")
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
        } footer: {
          if !viewModel.cityCountryString.isEmpty {
            Text("Your location is manually set and doesn't update automatically. To refresh your location, please fetch it again if you move to a new area.")
          }
        }
      }
    }
    .navigationTitle("Location")
    .onAppear {
      viewModel.resetHomeViewRefreshNotification()
    }
    .onDisappear {
      viewModel.onViewDisappear()
    }
    .overlay {
      if viewModel.gettingLocation {
        LoadingView()
      }
    }
    .onChange(of: viewModel.usingLocation, { _, _ in
      viewModel.sendHomeViewRefreshNotification()
    })
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
