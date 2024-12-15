import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_portfolio_app/main.dart';

void main() {
  testWidgets('Test for HomePage and Drawer Menu', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the HomePage is displayed.
    expect(find.text('Portfolio'), findsOneWidget);
    expect(find.text('Your Name'), findsOneWidget);
    expect(
        find.text('Flutter Developer | Mobile App Enthusiast'), findsOneWidget);

    // Verify the CircleAvatar is present.
    expect(find.byType(CircleAvatar), findsOneWidget);

    // Open the Drawer.
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    // Verify that the Drawer menu items are displayed.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('Instagram'), findsOneWidget);
    expect(find.text('GitHub'), findsOneWidget);

    // Tap the 'Logout' menu item and verify behavior.
    await tester.tap(find.text('Logout'));
    await tester.pump();

    // Verify the SnackBar message.
    expect(find.text('Logout successful!'), findsOneWidget);
  });
}
