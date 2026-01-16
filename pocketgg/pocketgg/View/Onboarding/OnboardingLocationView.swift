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
      Spacer()
      Image(systemName: "location.fill.viewfinder")
        .resizable()
        .frame(width: 100, height: 100)
        .fontWeight(.light)
        .foregroundStyle(.gray)
      Spacer()
      
      Toggle(isOn: $viewModel.usingLocation) {
        Text("Use Location")
          .font(.headline)
      }
      .padding(.horizontal, 5)
      
      if viewModel.usingLocation {
        Button {
          viewModel.getCurrentLocation()
        } label: {
          HStack {
            Image(systemName: "location.fill")
              .padding(.leading)
            Text("Get Current Location")
              .padding(.vertical)
            Spacer()
          }
          .frame(maxWidth: .infinity)
          .background(Color(uiColor: .secondarySystemBackground))
          .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        
        if !viewModel.cityCountryString.isEmpty {
          HStack {
            Text("Location:")
              .font(.headline)
            Spacer()
            Text(viewModel.cityCountryString)
          }
          .padding(.horizontal, 5)
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
