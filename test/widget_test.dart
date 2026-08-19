import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_count/main.dart';

void main() {
  testWidgets('updates the total from a note count', (tester) async {
    await tester.pumpWidget(const MoneyCountApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '2');
    await tester.pump();

    expect(find.text('৳ 2,000'), findsOneWidget);
    expect(find.text('দুই হাজার টাকা মাত্র'), findsOneWidget);
    expect(find.text('Two thousand taka only'), findsOneWidget);
  });

  testWidgets('adds a custom note from the editor', (tester) async {
    await tester.pumpWidget(const MoneyCountApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '300');
    await tester.tap(find.text('যোগ করুন'));
    await tester.pumpAndSettle();

    expect(find.text('৳300'), findsOneWidget);

    await tester.tap(find.text('পরিবর্তন সংরক্ষণ করুন'));
    await tester.pumpAndSettle();

    expect(find.text('৳300'), findsOneWidget);
  });
}
