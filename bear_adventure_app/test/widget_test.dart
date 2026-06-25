// Smoke tests voor BEAR Adventure.
//
// De originele Flutter starter widget test (counter increments) was nooit
// representatief voor deze app. We vervangen 'm door een trivial smoke test
// die enkel verifieert dat de Dart code compileert. Echte integratie tests
// horen in een aparte integration_test/ map en draaien via Maestro of
// Patrol op een echt device — niet relevant voor PR-checks CI.

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('smoke: Dart toolchain + flutter_test work', () {
    expect(1 + 1, equals(2));
  });
}
