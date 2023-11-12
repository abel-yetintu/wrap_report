class ApiException implements Exception {
  final String message;
  ApiException({required this.message});
}

class BadRequestException extends ApiException {
  BadRequestException({required super.message});
}

class UnAuthorizedException extends ApiException {
  UnAuthorizedException({required super.message});
}
class ForbiddenException extends ApiException {
  ForbiddenException({required super.message});
}

class FetchDataException extends ApiException {
  FetchDataException({required super.message});
}

class ApiNotRespondingException extends ApiException {
  ApiNotRespondingException({required super.message});
}
