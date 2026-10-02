import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saber/components/canvas/multi_finger_tap_detector.dart';

void main() {
  group('MultiFingerTapDetector', () {
    late List<int> taps;
    late MultiFingerTapDetector detector;

    setUp(() {
      taps = [];
      detector = MultiFingerTapDetector(onTap: taps.add);
    });

    void down(int pointer, int ms, [Offset position = Offset.zero]) =>
        detector.handleEvent(
          PointerDownEvent(
            pointer: pointer,
            timeStamp: Duration(milliseconds: ms),
            position: position,
          ),
        );
    void move(int pointer, int ms, Offset position) => detector.handleEvent(
      PointerMoveEvent(
        pointer: pointer,
        timeStamp: Duration(milliseconds: ms),
        position: position,
      ),
    );
    void up(int pointer, int ms) => detector.handleEvent(
      PointerUpEvent(
        pointer: pointer,
        timeStamp: Duration(milliseconds: ms),
      ),
    );

    test('reports a two-finger tap', () {
      down(1, 0);
      down(2, 20);
      up(1, 100);
      up(2, 120);
      expect(taps, [2]);
    });

    test('reports a three-finger tap', () {
      down(1, 0);
      down(2, 10);
      down(3, 20);
      up(2, 90);
      up(1, 100);
      up(3, 110);
      expect(taps, [3]);
    });

    test('ignores a single-finger tap', () {
      down(1, 0);
      up(1, 50);
      expect(taps, isEmpty);
    });

    test('ignores a pinch or pan', () {
      down(1, 0);
      down(2, 10);
      move(2, 50, const Offset(50, 0));
      up(1, 100);
      up(2, 110);
      expect(taps, isEmpty);
    });

    test('ignores a slow hold', () {
      down(1, 0);
      down(2, 10);
      up(1, 500);
      up(2, 510);
      expect(taps, isEmpty);
    });

    test('ignores a stylus', () {
      detector.handleEvent(
        const PointerDownEvent(pointer: 1, kind: PointerDeviceKind.stylus),
      );
      detector.handleEvent(
        const PointerDownEvent(pointer: 2, kind: PointerDeviceKind.stylus),
      );
      detector.handleEvent(
        const PointerUpEvent(pointer: 1, kind: PointerDeviceKind.stylus),
      );
      detector.handleEvent(
        const PointerUpEvent(pointer: 2, kind: PointerDeviceKind.stylus),
      );
      expect(taps, isEmpty);
    });

    test('starts fresh after a cancelled gesture', () {
      down(1, 0);
      down(2, 10);
      move(1, 20, const Offset(0, 40));
      up(1, 50);
      up(2, 60);
      down(3, 1000);
      down(4, 1010);
      up(3, 1100);
      up(4, 1110);
      expect(taps, [2]);
    });
  });
}
