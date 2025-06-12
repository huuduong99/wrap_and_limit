/*
 * Created by huuduong99 on 2025-06-12
 * Copyright (c) 2025
 * All rights reserved.
 *
 */

import 'package:flutter/widgets.dart';

/// A typedef for a callback function that is triggered when the size of a widget changes.
///
/// The callback receives a [Size] object representing the new dimensions of the widget.
typedef OnWidgetSizeChange = void Function(Size size);

/// A widget that measures the size of its child and notifies when the size changes.
///
/// The [MeasureSize] widget is useful for scenarios where you need to determine
/// the size of a widget after it has been rendered and react to changes in its size.
///
/// ### Parameters:
/// - [child]: The widget whose size needs to be measured.
/// - [onChange]: A callback function that is triggered when the size of the [child]
///   changes. The callback receives the new [Size] as a parameter. It will only be
///   called if the size changes and will not be triggered for [Size.zero].
///
/// ### Lifecycle:
/// - The size is measured after the widget is rendered using a post-frame callback.
/// - If the [child] widget changes, the size is re-measured.
///
/// ### Example:
/// ```dart
/// MeasureSize(
///   child: YourWidget(),
///   onChange: (size) {
///     print('New size: $size');
///   },
/// )
/// ```
class MeasureSize extends StatefulWidget {
  /// Widget to calculate it's size.
  final Widget child;

  /// [onChange] will be called when the [Size] changes.
  /// [onChange] will return the value ONLY once if it didn't change, and it will NOT return a value if it's equals to [Size.zero]
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    required this.child,
    required this.onChange,
    super.key,
  });

  @override
  State<MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  Size? oldSize;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MeasureSize oldWidget) {
    if (oldWidget.child != widget.child) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    }
    super.didUpdateWidget(oldWidget);
  }

  void _notifySize() {
    if (!mounted) return;

    final renderBox = context.findRenderObject();
    if (renderBox is RenderBox && renderBox.hasSize) {
      final newSize = renderBox.size;
      if (oldSize == null || oldSize != newSize) {
        oldSize = newSize;
        widget.onChange(newSize);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
