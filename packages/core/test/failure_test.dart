import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('equal failures share code, details, and retryable', () {
    const first = NetworkFailure(technicalDetails: 'timeout');
    const second = NetworkFailure(technicalDetails: 'timeout');

    expect(first, second);
    expect(first.hashCode, second.hashCode);
    expect(first.code, FailureCode.network);
    expect(first.retryable, isTrue);
  });

  test('different details are not equal', () {
    const first = NetworkFailure(technicalDetails: 'timeout');
    const second = NetworkFailure(technicalDetails: 'reset');

    expect(first, isNot(second));
  });

  test('different subtypes are not equal', () {
    const network = NetworkFailure(technicalDetails: 'down');
    const server = ServerFailure(technicalDetails: 'down');

    expect(network, isNot(server));
    expect(server.retryable, isTrue);
    expect(const ValidationFailure().retryable, isFalse);
    expect(const UnauthorizedFailure().code, FailureCode.unauthorized);
    expect(const ForbiddenFailure().code, FailureCode.forbidden);
    expect(const NotFoundFailure().code, FailureCode.notFound);
    expect(const ConflictFailure().code, FailureCode.conflict);
    expect(const ParsingFailure().code, FailureCode.parsing);
    expect(const UnknownFailure().code, FailureCode.unknown);
  });
}
