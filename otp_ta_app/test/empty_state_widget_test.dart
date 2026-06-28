import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otp_ta_app/shared_widgets/misc/empty_state_widget.dart';

void main() {
  testWidgets('EmptyStateWidget renders title and message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyStateWidget(
            title: 'No records yet',
            message: 'Create one to get started.',
            icon: Icons.inbox_outlined,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('No records yet'), findsOneWidget);
    expect(find.text('Create one to get started.'), findsOneWidget);
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
  });
}
