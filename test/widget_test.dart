import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// This must match pubspec.yaml → name: flutter_application_2
import 'package:flutter_application_2/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    
    // Load the app
    await tester.pumpWidget(const LeafDoctorApp());

    // Verify that the app launched successfully
    expect(find.byType(LeafDoctorApp), findsOneWidget);
  });
}