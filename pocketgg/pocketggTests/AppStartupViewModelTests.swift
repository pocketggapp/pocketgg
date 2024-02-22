import XCTest
@testable import pocketgg

final class AppStartupViewModelTests: XCTestCase {
  private var sut: AppStartupViewModel!
  private var userDefaults: UserDefaults!
  
  override func setUpWithError() throws {
    userDefaults = UserDefaults(suiteName: #file)
    userDefaults.removePersistentDomain(forName: #file)
    
    sut = AppStartupViewModel(
      oAuthService: MockOAuthService(),
      userDefaults: userDefaults
    )
  }
  
  override func tearDownWithError() throws {
    sut = nil
  }
  
  func testShouldRefreshAccessToken() async {
    guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
      XCTFail("Could not create Date() object for 'yesterday'")
      return
    }
    userDefaults.set(yesterday, forKey: Constants.accessTokenLastRefreshed)
    sut = AppStartupViewModel(
      oAuthService: MockOAuthService(),
      userDefaults: userDefaults
    )
    
    XCTAssertTrue(sut.shouldRefreshAccessToken())
  }
  
  func testShouldNotRefreshAccessToken() async {
    userDefaults.set(Date(), forKey: Constants.accessTokenLastRefreshed)
    sut = AppStartupViewModel(
      oAuthService: MockOAuthService(),
      userDefaults: userDefaults
    )
    
    XCTAssertFalse(sut.shouldRefreshAccessToken())
  }
}
