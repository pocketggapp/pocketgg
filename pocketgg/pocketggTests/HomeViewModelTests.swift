import XCTest
@testable import pocketgg

final class HomeViewModelTests: XCTestCase {
  private var sut: HomeViewModel!
  
  override func setUpWithError() throws {
    sut = HomeViewModel(service: MockStartggService())
  }
  
  override func tearDownWithError() throws {
    sut = nil
  }
  
  func testFetchTournaments() async {
    await sut.fetchTournaments()
    switch sut.state {
    case .loaded(let tournamentGroups):
      XCTAssertEqual(tournamentGroups.first?.tournaments, [
        MockStartggService.createTournament(id: 0),
        MockStartggService.createTournament(id: 1),
        MockStartggService.createTournament(id: 2),
      ])
    default:
      XCTFail()
    }
  }
}
