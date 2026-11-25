// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jahc/main.dart';

void main() {
  testWidgets('PortfolioWeb renders Mark v3 card and interactions on desktop',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PortfolioWeb());
    expect(find.byType(PortfolioWeb), findsOneWidget);
    // Frame 1 renders above-the-fold Hero immediately; Frame 2 hydrates below-the-fold sections
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));

    expect(find.text('Mark v3'), findsOneWidget);
    expect(
      find.textContaining('Caleni Telematics para rastreo GPS'),
      findsOneWidget,
    );
    expect(
      find.byTooltip('Descargar en Google Play (Android)'),
      findsOneWidget,
    );
    expect(find.text('iOS · Próximamente'), findsOneWidget);

    final markImageFinder = find.byWidgetPredicate((w) {
      if (w is! Image) return false;
      final provider = w.image is ResizeImage
          ? (w.image as ResizeImage).imageProvider
          : w.image;
      return provider is AssetImage && provider.assetName == 'assets/mark/1.jpg';
    });
    expect(markImageFinder, findsOneWidget);
    await tester.ensureVisible(markImageFinder);
    await tester.pump(const Duration(milliseconds: 600));

    // Open lightbox preview when tapping the first Mark v3 screenshot
    await tester.tap(markImageFinder);
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump(const Duration(milliseconds: 600));

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('PortfolioWeb renders Mark v3 card without overflow on mobile',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PortfolioWeb());
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));

    expect(find.text('Mark v3'), findsOneWidget);
    expect(
      find.byTooltip('Descargar en Google Play (Android)'),
      findsOneWidget,
    );
    expect(find.text('iOS · Próximamente'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 5));
  });
}
