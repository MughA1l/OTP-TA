import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otp_ta_app/core/utils/validators.dart';
import 'package:otp_ta_app/shared_widgets/buttons/primary_button.dart';
import 'package:otp_ta_app/shared_widgets/inputs/app_text_field.dart';
import 'package:otp_ta_app/shared_widgets/chips/status_chip.dart';

void main() {
  testWidgets('PrimaryButton renders label and loading state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(label: 'Continue', onPressed: () {}),
        ),
      ),
    );

    expect(find.text('Continue'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('AppTextField shows validation feedback', (tester) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: AppTextField(
              controller: controller,
              label: 'Email',
              validator: Validators.validateEmail,
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'bad-email');
    formKey.currentState!.validate();
    await tester.pump();
    expect(find.text('Enter a valid email address.'), findsOneWidget);
  });

  testWidgets('StatusChip renders with provided label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatusChip(label: 'Completed', color: Colors.green),
        ),
      ),
    );

    expect(find.text('Completed'), findsOneWidget);
  });
}
