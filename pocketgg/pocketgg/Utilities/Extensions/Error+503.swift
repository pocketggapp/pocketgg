import Apollo

extension Error {
  var is503Error: Bool {
    if let responseCodeError = self as? ResponseCodeInterceptor.ResponseCodeError {
      switch responseCodeError {
      case .invalidResponseCode(let response, _):
        return response?.statusCode == 503
      }
    } else {
      return false
    }
  }
}
