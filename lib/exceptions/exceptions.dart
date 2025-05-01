class UsernameAlreadyExistsException implements Exception {
  final String message;

  UsernameAlreadyExistsException(this.message);
}

class EmailAlreadyExistsException implements Exception {
  final String message;

  EmailAlreadyExistsException(this.message);
}
