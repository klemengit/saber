import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saber/data/pencil_double_tap.dart';

void main() {
  group('PencilDoubleTap', () {
    var taps = 0;
    void listener() => taps++;

    setUp(() {
      taps = 0;
      PencilDoubleTap.addListener(listener);
    });
    tearDown(() => PencilDoubleTap.removeListener(listener));

    test('notifies listeners on a double tap', () async {
      await PencilDoubleTap.handleMethodCall(
        const MethodCall('doubleTap', 'toggle'),
      );
      expect(taps, 1);
    });

    test('respects the system setting to ignore double taps', () async {
      await PencilDoubleTap.handleMethodCall(
        const MethodCall('doubleTap', 'ignore'),
      );
      expect(taps, 0);
    });

    test('stops notifying removed listeners', () async {
      PencilDoubleTap.removeListener(listener);
      await PencilDoubleTap.handleMethodCall(
        const MethodCall('doubleTap', 'toggle'),
      );
      expect(taps, 0);
    });
  });
}
