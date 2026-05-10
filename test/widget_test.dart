import 'package:flutter_test/flutter_test.dart';
import 'package:peerconnect/app.dart';

void main() {
  testWidgets('GuardianNet app smoke test', (WidgetTester tester) async {
    // Verify the app widget can be constructed
    expect(const GuardianNetApp(), isNotNull);
  });
}
