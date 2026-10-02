import 'package:flutter/material.dart';
import 'package:saber/components/toolbar/size_picker.dart';
import 'package:saber/data/extensions/axis_extensions.dart';
import 'package:saber/data/prefs.dart';
import 'package:saber/data/tools/shape_tool.dart';

/// The options row for [ShapeTool]: its size,
/// and which [ShapeKind] to draw.
class ShapeModal extends StatefulWidget {
  const new({super.key});

  @override
  State<ShapeModal> createState() => _ShapeModalState();
}

class _ShapeModalState extends State<ShapeModal> {
  @override
  Widget build(BuildContext context) {
    final axis = stows.editorToolbarAlignment.value.axis.opposite;
    final tool = ShapeTool.currentShapeTool;
    final colorScheme = ColorScheme.of(context);

    return Flex(
      direction: axis,
      mainAxisAlignment: .center,
      children: [
        SizePicker(axis: axis, pen: tool),
        for (final kind in ShapeKind.values) ...[
          const SizedBox.square(dimension: 8),
          IconButton(
            onPressed: () => setState(() => tool.kind = kind),
            style: TextButton.styleFrom(
              foregroundColor: tool.kind == kind
                  ? colorScheme.secondary
                  : colorScheme.onSurface,
              backgroundColor: tool.kind == kind
                  ? colorScheme.secondary.withValues(alpha: 0.1)
                  : Colors.transparent,
              shape: const CircleBorder(),
            ),
            tooltip: kind.label,
            icon: Icon(kind.icon),
          ),
        ],
      ],
    );
  }
}
