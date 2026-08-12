import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrap_and_limit/wrap_and_limit.dart';

void main() {
  testWidgets('WrapAndLimit renders correctly and handles overflow',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: WrapAndLimit(
              maxRow: 2,
              spacing: 4,
              runSpacing: 4,
              children: List.generate(
                10,
                (index) => SizedBox(
                  width: 50,
                  height: 20,
                  child: Text('Item $index'),
                ),
              ),
              overflowWidget: (restCount) => Text('+$restCount'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Item 0'), findsOneWidget);
    expect(find.byType(WrapAndLimit), findsOneWidget);
  });
}
