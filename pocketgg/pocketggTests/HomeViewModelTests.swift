import XCTest
@testable import pocketgg

final class HomeViewModelTests: XCTestCase {
  private var sut: HomeViewModel!
  private var userDefaults: UserDefaults!
  
  override func setUpWithError() throws {
    userDefaults = UserDefaults(suiteName: #file)
    userDefaults.removePersistentDomain(forName: #file)
    
    sut = HomeViewModel(
      oAuthService: MockOAuthService(),
      service: MockStartggService(),
      userDefaults: userDefaults
    )
  }
  
  override func tearDownWithError() throws {
    sut = nil
  }
  
  func testTournamentFetch() async {
    await sut.fetchTournaments()
    
    XCTAssertTrue(sut.didAttemptTokenRefresh)
    // TODO: Test sut.state
  }
  
  func testTournamentFetchWithPreviousAccessToken() async {
    guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
      XCTFail("Could not create Date() object for 'yesterday'")
      return
    }
    userDefaults.set(yesterday, forKey: Constants.UserDefaults.accessTokenLastRefreshed)
    sut = HomeViewModel(
      oAuthService: MockOAuthService(),
      service: MockStartggService(),
      userDefaults: userDefaults
    )
    
    await sut.fetchTournaments()
    
    XCTAssertTrue(sut.didAttemptTokenRefresh)
    // TODO: Test sut.state
  }
  
  
  func testTournamentFetchWithoutAccessTokenRefresh() async {
    userDefaults.set(Date(), forKey: Constants.UserDefaults.accessTokenLastRefreshed)
    sut = HomeViewModel(
      oAuthService: MockOAuthService(),
      service: MockStartggService(),
      userDefaults: userDefaults
    )
    
    await sut.fetchTournaments()
    
    XCTAssertFalse(sut.didAttemptTokenRefresh)
    // TODO: Test sut.state
  }
  
  func testTournamentFetchWithOldAccessToken() async {
    // TODO: Move user back to LoginView
  }
}
