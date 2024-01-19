import XCTest
@testable import pocketgg

final class LoginViewModelTests: XCTestCase {
  private var sut: LoginViewModel!

    override func setUpWithError() throws {
        sut = LoginViewModel(oAuthService: MockOAuthService())
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testLogInSuccess() async {
      await sut.logIn()
      
      XCTAssertTrue(sut.loggedInSuccessfully)
      XCTAssertFalse(sut.showingAlert)
      XCTAssertTrue(sut.alertMessage.isEmpty)
    }

    func testLogInFailure() async {
        sut = LoginViewModel(oAuthService: MockOAuthService(testSuccess: false))
      await sut.logIn()
      
      XCTAssertFalse(sut.loggedInSuccessfully)
      XCTAssertTrue(sut.showingAlert)
      XCTAssertFalse(sut.alertMessage.isEmpty)
    }
}
