final class MockOAuthService: OAuthServiceType {
  var testSuccess: Bool
  
  init(testSuccess: Bool = true) {
    self.testSuccess = testSuccess
  }
  
  func webAuthAsync() async throws -> AccessTokenResponse {
    guard testSuccess else { throw OAuthError.invalidData }
    return AccessTokenResponse(
      accessToken: "4eeFpL20Adsbf6h12sd8mdfwEzF",
      tokenType: "Bearer",
      expiresIn: 604800,
      refreshToken: "d8md12s4eeAdsbf6fwEzF0hFpL2"
    )
  }
  
  func refreshAccessToken() async throws -> AccessTokenResponse {
    guard testSuccess else { throw OAuthError.invalidData }
    return AccessTokenResponse(
      accessToken: "4eeFpL20Adsbf6h12sd8mdfwEzF",
      tokenType: "Bearer",
      expiresIn: 604800,
      refreshToken: "d8md12s4eeAdsbf6fwEzF0hFpL2"
    )
  }
  
  func saveTokens(_ response: AccessTokenResponse) async throws { }
}
