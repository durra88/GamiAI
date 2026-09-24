import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('when branches to success', () {
    const result = Success<int>(7);

    final value = result.when(
      success: (value) => value,
      failure: (failure) => failure.code.index,
    );

    expect(value, 7);
    expect(result, const Success<int>(7));
  });

  test('when branches to failure', () {
    const failure = NotFoundFailure(technicalDetails: 'missing');
    const result = FailureResult<int>(failure);

    final code = result.when(
      success: (value) => FailureCode.unknown,
      failure: (failure) => failure.code,
    );

    expect(code, FailureCode.notFound);
    expect(result, const FailureResult<int>(failure));
    expect(
      const FailureResult<int>(NotFoundFailure()),
      isNot(const FailureResult<int>(UnknownFailure())),
    );
  });
}
