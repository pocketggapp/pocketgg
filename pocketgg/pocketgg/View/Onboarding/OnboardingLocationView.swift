import SwiftUI

struct OnboardingLocationView: View {
  @StateObject private var viewModel: LocationPreferenceViewModel
  
  private let content: OnboardingContent
  
  init(content: OnboardingContent) {
    self._viewModel = StateObject(wrappedValue: {
      LocationPreferenceViewModel()
    }())
    self.content = content
  }
  
  var body: some View {
    VStack(spacing: 10) {
      Toggle(isOn: $viewModel.usingLocation) {
        Text("Use Location")
          .font(.headline)
      }
      
      if viewModel.usingLocation {
        Button("Get Current Location", systemImage: "location.fill") {
          viewModel.getCurrentLocation()
        }
        .buttonStyle(.bordered)
        
        if !viewModel.cityCountryString.isEmpty {
          Text("Location: " + viewModel.cityCountryString)
        }
      }
      
      VStack(spacing: 10) {
        Text(content.title)
          .multilineTextAlignment(.center)
          .font(.largeTitle.bold())
        
        Text(content.subtitle)
          .multilineTextAlignment(.center)
      }
      .padding(.top, 32)
    }
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
  }
}

#Preview {
  OnboardingLocationView(content: MockOnboardingContentService.createLocationSlideContent())
}
