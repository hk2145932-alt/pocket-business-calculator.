import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_business_calculator/main.dart';

void main() {
  testWidgets('home screen loads', (tester) async {
    await tester.pumpWidget(const PocketBusinessCalculatorApp());

    expect(find.text('Pocket Business Calculator'), findsOneWidget);
    expect(find.text('Quick Calculator'), findsOneWidget);
    expect(find.text('Profit Margin'), findsOneWidget);
  });
}
