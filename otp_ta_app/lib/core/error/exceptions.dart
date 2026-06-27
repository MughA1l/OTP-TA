class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'An unexpected server error occurred']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Failed to load data from cache']);
}

class AuthException implements Exception {
  final String message;
  AuthException([this.message = 'Authentication failed']);
}
