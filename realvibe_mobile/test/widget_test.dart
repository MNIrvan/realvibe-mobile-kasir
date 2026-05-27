import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:realvibe_mobile/dashboard/dashboard_page.dart';

void main() {
  testWidgets('renders admin dashboard on mobile and opens drawer', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardPage(),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Real-Vibe Admin'), findsOneWidget);
    expect(find.text('Grafik Pendapatan'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu).first);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });
}
