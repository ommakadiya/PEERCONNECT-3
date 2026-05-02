import 'package:flutter_test/flutter_test.dart';
import 'package:peerconnect/app.dart';

void main() {
  testWidgets('PeerConnect app smoke test', (WidgetTester tester) async {
    // Verify the app widget can be constructed
    expect(const PeerConnectApp(), isNotNull);
  });
}
