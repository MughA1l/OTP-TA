abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

class FirestoreFailure extends Failure {
  const FirestoreFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection.'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class StorageFailure extends Failure {
  const StorageFailure({required super.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}
