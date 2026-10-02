import 'package:flutter/gestures.dart';

/// Detects quick taps with several fingers at once,
/// e.g. a two-finger tap to undo.
///
/// Feed it every pointer event from a [Listener].
/// A tap is reported when all fingers have lifted,
/// none of them moved more than [maxMovement],
/// and the whole gesture took less than [maxDuration].
/// Stylus and mouse pointers are ignored.
class MultiFingerTapDetector {
  new({required this.onTap});

  /// Called with the number of fingers used in the tap.
  final void Function(int fingers) onTap;

  /// How far a finger may move, in logical pixels,
  /// before the gesture counts as a pan or zoom.
  static const maxMovement = 20.0;

  /// The longest a tap can take, from the first finger down
  /// to the last finger up.
  static const maxDuration = Duration(milliseconds: 300);

  final _startPositions = <int, Offset>{};
  Duration _startTime = .zero;
  var _maxFingers = 0;
  var _cancelled = false;

  void handleEvent(PointerEvent event) {
    if (event.kind != PointerDeviceKind.touch) return;

    switch (event) {
      case PointerDownEvent():
        if (_startPositions.isEmpty) {
          _startTime = event.timeStamp;
          _maxFingers = 0;
          _cancelled = false;
        }
        _startPositions[event.pointer] = event.position;
        if (_startPositions.length > _maxFingers) {
          _maxFingers = _startPositions.length;
        }
      case PointerMoveEvent():
        final start = _startPositions[event.pointer];
        if (start != null && (event.position - start).distance > maxMovement) {
          _cancelled = true;
        }
      case PointerUpEvent():
        if (_startPositions.remove(event.pointer) == null) return;
        if (_startPositions.isNotEmpty) return;
        final duration = event.timeStamp - _startTime;
        if (!_cancelled && _maxFingers >= 2 && duration <= maxDuration) {
          onTap(_maxFingers);
        }
      case PointerCancelEvent():
        _startPositions.remove(event.pointer);
        _cancelled = true;
      default:
        break;
    }
  }
}
